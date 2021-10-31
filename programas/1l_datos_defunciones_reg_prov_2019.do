
* Importar la base de datos de excel

import excel "${datos}\raw\base_sinadef_2019.xlsx", firstrow clear

* Borrar los registros que se anularon
drop if ESTADO == "ANULACIÓN SOLICITADA" | ESTADO == "ANULADO"

* Renombrar la provincia
rename PROVINCIADOMICILIO provincia

* Generamos la fecha adecuando al formato conveniente y la ordenamos
gen fecha = mdy(MES, DIA, AÑO)
format fecha %td
sort fecha

* Borramos duplicados de DNI
rename DOCUMENTO dni
sort dni
duplicates report dni
duplicates tag dni, gen(repe_def)
quietly by dni: gen repeti_def = cond(_N==1,0,_n)

set seed 98034
generate u1 = runiform()

tostring u1, replace force
replace dni = u1 if dni == "SIN REGISTRO"
replace dni = u1 if dni == ""
duplicates drop dni, force

*********************************************************************************
* Colapsamos para tener una serie de tiempo diaria
********************************************************************************


* Guardar días 29, 30, y 31 de diciembre como parte de la SE1 del 2020
preserve
keep if fecha >= d(29dec2019)
save "${datos}\temporal\defunciones_totales_region_2019_2020.dta", replace
restore 

gen numero = _n
* Datos regionales
preserve 
collapse (count) numero, by(fecha)
rename numero de_19
tsset fecha, daily
tsfill

* Datos semanales
gen semana = .
replace semana = 1 if fecha == 21550 | fecha == 21551 | fecha == 21552 | fecha == 21553 | fecha == 21554
replace semana = 2 if fecha > 21554 & fecha <= 21561
replace semana = semana[_n-7] + 1 if fecha > 21561
drop if semana >= 53
* Conteo
collapse (sum) de_19, by(semana)

save "${datos}\output\defunciones_totales_region_2019.dta", replace

restore

* Datos provinciales

* Para identificar los migrantes
rename provincia provincia_vivienda

gen provincia_reside = .
replace provincia_reside = 1 if provincia_vivienda == "ACOMAYO"
replace provincia_reside = 2 if provincia_vivienda == "ANTA"
replace provincia_reside = 3 if provincia_vivienda == "CALCA"
replace provincia_reside = 4 if provincia_vivienda == "CANAS"
replace provincia_reside = 5 if provincia_vivienda == "CANCHIS"
replace provincia_reside = 6 if provincia_vivienda == "CHUMBIVILCAS"
replace provincia_reside = 7 if provincia_vivienda == "CUSCO"
replace provincia_reside = 8 if provincia_vivienda == "ESPINAR"
replace provincia_reside = 9 if provincia_vivienda == "LA CONVENCION"
replace provincia_reside = 10 if provincia_vivienda == "PARURO"
replace provincia_reside = 11 if provincia_vivienda == "PAUCARTAMBO"
replace provincia_reside = 12 if provincia_vivienda == "QUISPICANCHI"
replace provincia_reside = 13 if provincia_vivienda == "URUBAMBA"
replace provincia_reside = 14 if provincia_reside == . 
*tab provincia_reside

* Etiquetar
label define provincia_reside 1 "ACOMAYO" 2 "ANTA" 3 "CALCA" 4 "CANAS" 5 "CANCHIS" 6 "CHUMBIVILCAS" 7 "CUSCO" 8 "ESPINAR" 9 "LA CONVENCION" 10 "PARURO" 11 "PAUCARTAMBO" 12 "QUISPICANCHI" 13 "URUBAMBA" 14 "OTROS"
label values provincia_reside provincia_reside
*tab provincia_reside

* Generar los datos primeros diarias para luego semanales
forvalues t = 1/13 {

preserve 

keep if provincia_reside == `t'

collapse (count) numero, by(fecha)

rename numero d19_`t'

tsset fecha, daily
tsfill

save "${datos}\temporal\exceso_provincias_2019_`t'.dta", replace

restore
}

use "${datos}\temporal\exceso_provincias_2019_1.dta", clear

forvalues i=2/13 {
merge 1:1 fecha using "${datos}\temporal\exceso_provincias_2019_`i'.dta", nogen
}

recode * (.=0)

* Generar datos semanales
gen semana = .
replace semana = 1 if fecha == 21550 | fecha == 21551 | fecha == 21552 | fecha == 21553 | fecha == 21554
replace semana = 2 if fecha > 21554 & fecha <= 21561
replace semana = semana[_n-7] + 1 if fecha > 21561
drop if semana >= 53
* Creo que esto cambia
collapse (sum) d19_*, by(semana)

save "${datos}\output\defunciones_totales_provincial_2019.dta", replace
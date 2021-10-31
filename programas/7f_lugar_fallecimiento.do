
import excel "${datos}\raw\base_sinadef_2021.xlsx", sheet("DATA") firstrow clear

keep if DEPARTAMENTO == "CUSCO"

drop if Nº == .

drop if ESTADO == "ANULACIÓN SOLICITADA" | ESTADO == "ANULADO"

gen distrito = DISTRITORESDIDENCIAHABITUAL
gen departamento = DEPARTAMENTO
gen direccion = DIRECCIONDEDOMICILIO
*gen provincia = PROVINCIADERESIDENCIAHABITUAL

*append using "datos\output/base_sinadef_2020.dta", force

* Generar la variable de identificación
rename DOCUMENTO dni

destring MES, replace force
destring AÑO, replace force 
gen fecha_sinadef = mdy(MES,DIA,AÑO)
format fecha_sinadef %td

* Indicador de defunciones por COVID
gen defuncion =.
replace defuncion = 1
replace defuncion = 0 if defuncion == .

* Juntar 
*merge m:1 distrito using "datos\output\ubigeos.dta"

* Otras variables relevantes para que sean similares a la base NOTICOVID y SISCOVID
rename SEXO sexo
*rename EDAD edad
*destring edad, replace

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

keep if fecha_sinadef >= d(01jan2021) & fecha_sinadef <= d(17jul2021)

tab LUGARDEFALLECIMIENTO

****
gen lugar = .
replace lugar = 1 if LUGARDEFALLECIMIENTO == "ADOLFO GUEVARA VELASCO"
replace lugar = 2 if LUGARDEFALLECIMIENTO == "HOSPITAL DE APOYO DEPARTAMENTAL CUSCO"
replace lugar = 3 if LUGARDEFALLECIMIENTO == "ANTONIO LORENA DEL CUSCO"
replace lugar = 4 if LUGARDEFALLECIMIENTO == "ESPINAR" | LUGARDEFALLECIMIENTO == "QUILLABAMBA" | LUGARDEFALLECIMIENTO == "SAN JUAN DE KIMBIRI-VRAEM" | LUGARDEFALLECIMIENTO == "SANTO TOMAS" | LUGARDEFALLECIMIENTO == "SICUANI" 
replace lugar = 5 if LUGARDEFALLECIMIENTO == "C.M. SANTIAGO  ESSALUD" |  LUGARDEFALLECIMIENTO == "C.M. SANTIAGO  ESSALUD" |  LUGARDEFALLECIMIENTO == "CAS URUBAMBA -ESSALUD" |  LUGARDEFALLECIMIENTO == "ESPINAR - ESSALUD" |  LUGARDEFALLECIMIENTO == "ESSALUD SICUANI" |  LUGARDEFALLECIMIENTO == "QUILLABAMBA - ESSALUD" 
replace lugar = 6 if LUGARDEFALLECIMIENTO == "ACOMAYO" | LUGARDEFALLECIMIENTO == "ANTA" | LUGARDEFALLECIMIENTO == "CACHIMAYO" | LUGARDEFALLECIMIENTO == "CALCA" | LUGARDEFALLECIMIENTO == "HUANCARANI" | LUGARDEFALLECIMIENTO == "HUAROCONDO" | LUGARDEFALLECIMIENTO == "LIVITACA" | LUGARDEFALLECIMIENTO == "MARAS" | LUGARDEFALLECIMIENTO == "OCONGATE" | LUGARDEFALLECIMIENTO == "OLLANTAYTAMBO" | LUGARDEFALLECIMIENTO == "PACCARECTAMBO" | LUGARDEFALLECIMIENTO == "PICHARI" | LUGARDEFALLECIMIENTO == "POMACANCHI" | LUGARDEFALLECIMIENTO == "QUELLOUNO" | LUGARDEFALLECIMIENTO == "URCOS" | LUGARDEFALLECIMIENTO == "URUBAMBA" | LUGARDEFALLECIMIENTO == "YANAOCA" | LUGARDEFALLECIMIENTO == "SAN SALVADOR" | LUGARDEFALLECIMIENTO == "VILLA VIRGEN" | LUGARDEFALLECIMIENTO == "PARURO"
replace lugar = 7 if LUGARDEFALLECIMIENTO == "CIMA S.A.C." | LUGARDEFALLECIMIENTO == "CIMA SO CUSCO" | LUGARDEFALLECIMIENTO == "DENTAL PARK CUSCO SAC" | LUGARDEFALLECIMIENTO == "HOGAR CLINICA SAN JUAN DE DIOS-CUSCO" | LUGARDEFALLECIMIENTO == "OXIGEN MEDICAL NETWORK" | LUGARDEFALLECIMIENTO == "PARDO" | LUGARDEFALLECIMIENTO == "TECHO OBRERO"
replace lugar = 8 if LUGARDEFALLECIMIENTO == "CENTRO LABORAL" | LUGARDEFALLECIMIENTO == "DOMICILIO" | LUGARDEFALLECIMIENTO == "EN TRANSITO" | LUGARDEFALLECIMIENTO == "OTRO" | LUGARDEFALLECIMIENTO == "VIA PUBLICA"
label var lugar "Lugar"
label define lugar  1 "Hospital Nacional Adolfo Guevara" 2 "Hospital de Apoyo Departamental Cusco" 3 "Hospital Antonio Lorena" 4 "Hospitales Nivel II MINSA" 5 "Hospital Nivel II ESSALUD" 6 "Establecimientos Nivel I" 7 "Clínicas" 8 "Otros"
label values lugar lugar

* Verificar
sort lugar
*br lugar LUGARDEFALLECIMIENTO

*tab lugar

graph hbar (percent), over(lugar) graphregion(color(white)) ///
blabel(bar, format(%4.1f)) bar(1, fcolor("$mycolor5") lcolor("$mycolor5")) ///
bgcolor(white) ///
ylabel(, nogrid) ///
ytitle("Defunciones (%)")

graph export "figuras\lugar_defuncion.png", as(png) replace
graph export "figuras\lugar_defuncion.pdf", as(pdf) replace



use "${datos}\output\base_vacunados", clear

merge m:1 ubigeo using "${datos}\output\ubigeos"

drop if edad < 12
drop if missing(edad)
drop if edad > 109

* Generar las categorías de las etapas de vida
gen grupo_edad = .
replace grupo_edad = 1 if edad >= 12 & edad <= 19
replace grupo_edad = 2 if edad >= 20 & edad <= 29
replace grupo_edad = 3 if edad >= 30 & edad <= 39
replace grupo_edad = 4 if edad >= 40 & edad <= 49
replace grupo_edad = 5 if edad >= 50 & edad <= 59
replace grupo_edad = 6 if edad >= 60 & edad <= 69
replace grupo_edad = 7 if edad >= 70 & edad <= 79
replace grupo_edad = 8 if edad >= 80 
label variable grupo_edad "Grupo de Edad"
label define grupo_edad 1 "12-19 años" 2 "20-29 años" 3 "30-39 años" 4 "40-49 años" 5 "50-59 años" 6 "60-69 años" 7 "70-79 años" 8 "80 a más años"
label values grupo_edad grupo_edad
tab grupo_edad

* Añadir el distrito de Kimpirushiato a LC
replace provincia = "LA CONVENCION" if ubigeo == "080915"

gen provincia_residencia =.
replace provincia_residencia = 1 if provincia == "ACOMAYO"
replace provincia_residencia = 2 if provincia == "ANTA"
replace provincia_residencia = 3 if provincia == "CALCA"
replace provincia_residencia = 4 if provincia == "CANAS"
replace provincia_residencia = 5 if provincia == "CANCHIS"
replace provincia_residencia = 6 if provincia == "CHUMBIVILCAS"
replace provincia_residencia = 7 if provincia == "CUSCO"
replace provincia_residencia = 8 if provincia == "ESPINAR"
replace provincia_residencia = 9 if provincia == "LA CONVENCION"
replace provincia_residencia = 10 if provincia == "PARURO"
replace provincia_residencia = 11 if provincia == "PAUCARTAMBO"
replace provincia_residencia = 12 if provincia == "QUISPICANCHI"
replace provincia_residencia = 13 if provincia == "URUBAMBA"
label variable provincia_residencia "provincia de residencia"
label define provincia_residencia 1 "Acomayo" 2 "Anta" 3 "Calca" 4 "Canas" 5 "Canchis" 6 "Chumbivilcas" 7 "Cusco" 8 "Espinar" 9 "La Convención" 10 "Paruro" 11 "Paucartambo" 12 "Quispicanchi" 13 "Urubambda"
label values provincia_residencia provincia_residencia

gen numero = _n

replace dosis = 2 if dosis == 3

save "${datos}\output\base_vacunados_variables", replace

*use "datos\output\base_vacunados_variables", clear

forvalues i = 1/2 {

forvalues j=1/8 {
preserve
keep if dosis == `i'
keep if grupo_edad == `j'

collapse (count) numero, by(provincia_residencia)

*tsset fecha_resultado, daily
*tsfill 

rename numero numero_`i'_`j'

save "${datos}\temporal\vacunados_`i'_`j'.dta", replace

restore

}

}

forvalues i=1/2 {

	use "${datos}\temporal\vacunados_`i'_1.dta", clear

		forvalues j = 2/8 {

		merge 1:1 provincia_residencia using "${datos}\temporal\vacunados_`i'_`j'.dta", nogen

		}

	save "${datos}\temporal\vacunados_`i'.dta", replace

}

use "${datos}\temporal\vacunados_1.dta", clear

merge 1:1 provincia_residencia using "${datos}\temporal\vacunados_2.dta", nogen

* Crear los objetivos

gen objetivo_1 = .
replace objetivo_1 = 4775 if provincia_residencia == 1
replace objetivo_1 = 8609 if provincia_residencia == 2
replace objetivo_1 = 11595 if provincia_residencia == 3
replace objetivo_1 = 6527 if provincia_residencia == 4
replace objetivo_1 = 16151 if provincia_residencia == 5
replace objetivo_1 = 13964 if provincia_residencia == 6
replace objetivo_1 = 64095 if provincia_residencia == 7
replace objetivo_1 = 10621 if provincia_residencia == 8
replace objetivo_1 = 30455 if provincia_residencia == 9
replace objetivo_1 = 5109 if provincia_residencia == 10
replace objetivo_1 = 9594 if provincia_residencia == 11
replace objetivo_1 = 17364 if provincia_residencia == 12
replace objetivo_1 = 10169 if provincia_residencia == 13

gen objetivo_2 = .
replace objetivo_2 = 5209 if provincia_residencia == 1
replace objetivo_2 = 12308 if provincia_residencia == 2
replace objetivo_2 = 14001 if provincia_residencia == 3
replace objetivo_2 = 8082 if provincia_residencia == 4
replace objetivo_2 = 21370 if provincia_residencia == 5
replace objetivo_2 = 15726 if provincia_residencia == 6
replace objetivo_2 = 87231 if provincia_residencia == 7
replace objetivo_2 = 12398 if provincia_residencia == 8
replace objetivo_2 = 38240 if provincia_residencia == 9
replace objetivo_2 = 6303 if provincia_residencia == 10
replace objetivo_2 = 10018 if provincia_residencia == 11
replace objetivo_2 = 19602 if provincia_residencia == 12
replace objetivo_2 = 13562 if provincia_residencia == 13

gen objetivo_3 = .
replace objetivo_3 = 3169 if provincia_residencia == 1
replace objetivo_3 = 10049 if provincia_residencia == 2
replace objetivo_3 = 11194 if provincia_residencia == 3
replace objetivo_3 = 5540 if provincia_residencia == 4
replace objetivo_3 = 16477 if provincia_residencia == 5
replace objetivo_3 = 10150 if provincia_residencia == 6
replace objetivo_3 = 83818 if provincia_residencia == 7
replace objetivo_3 = 9741 if provincia_residencia == 8
replace objetivo_3 = 34245 if provincia_residencia == 9
replace objetivo_3 = 4483 if provincia_residencia == 10
replace objetivo_3 = 7119 if provincia_residencia == 11
replace objetivo_3 = 15011 if provincia_residencia == 12
replace objetivo_3 = 13039 if provincia_residencia == 13

gen objetivo_4 = .
replace objetivo_4 = 3119 if provincia_residencia == 1
replace objetivo_4 = 7895 if provincia_residencia == 2
replace objetivo_4 = 9522 if provincia_residencia == 3
replace objetivo_4 = 4818 if provincia_residencia == 4
replace objetivo_4 = 13368 if provincia_residencia == 5
replace objetivo_4 = 8786 if provincia_residencia == 6
replace objetivo_4 = 66816 if provincia_residencia == 7
replace objetivo_4 = 7740 if provincia_residencia == 8
replace objetivo_4 = 28102 if provincia_residencia == 9
replace objetivo_4 = 3979 if provincia_residencia == 10
replace objetivo_4 = 6003 if provincia_residencia == 11
replace objetivo_4 = 11815 if provincia_residencia == 12
replace objetivo_4 = 10229 if provincia_residencia == 13

gen objetivo_5 = .
replace objetivo_5 = 2905 if provincia_residencia == 1
replace objetivo_5 = 7141 if provincia_residencia == 2
replace objetivo_5 = 7545 if provincia_residencia == 3
replace objetivo_5 = 4280 if provincia_residencia == 4
replace objetivo_5 = 11242 if provincia_residencia == 5
replace objetivo_5 = 7834 if provincia_residencia == 6
replace objetivo_5 = 46211 if provincia_residencia == 7
replace objetivo_5 = 6318 if provincia_residencia == 8
replace objetivo_5 = 21673 if provincia_residencia == 9
replace objetivo_5 = 3751 if provincia_residencia == 10
replace objetivo_5 = 4569 if provincia_residencia == 11
replace objetivo_5 = 8894 if provincia_residencia == 12
replace objetivo_5 = 7491 if provincia_residencia == 13

gen objetivo_6 = .
replace objetivo_6 = 1800 if provincia_residencia == 1
replace objetivo_6 = 4878 if provincia_residencia == 2
replace objetivo_6 = 5010 if provincia_residencia == 3
replace objetivo_6 = 3022 if provincia_residencia == 4
replace objetivo_6 = 7346 if provincia_residencia == 5
replace objetivo_6 = 6033 if provincia_residencia == 6
replace objetivo_6 = 29800 if provincia_residencia == 7
replace objetivo_6 = 4367 if provincia_residencia == 8
replace objetivo_6 = 13838 if provincia_residencia == 9
replace objetivo_6 = 2631 if provincia_residencia == 10
replace objetivo_6 = 2933 if provincia_residencia == 11
replace objetivo_6 = 5850 if provincia_residencia == 12
replace objetivo_6 = 4701 if provincia_residencia == 13

gen objetivo_7 = .
replace objetivo_7 = 1330 if provincia_residencia == 1
replace objetivo_7 = 2999 if provincia_residencia == 2
replace objetivo_7 = 2940 if provincia_residencia == 3
replace objetivo_7 = 1906 if provincia_residencia == 4
replace objetivo_7 = 4408 if provincia_residencia == 5
replace objetivo_7 = 3592 if provincia_residencia == 6
replace objetivo_7 = 15860 if provincia_residencia == 7
replace objetivo_7 = 2550 if provincia_residencia == 8
replace objetivo_7 = 6919 if provincia_residencia == 9
replace objetivo_7 = 1733 if provincia_residencia == 10
replace objetivo_7 = 1657 if provincia_residencia == 11
replace objetivo_7 = 3374 if provincia_residencia == 12
replace objetivo_7 = 2596 if provincia_residencia == 13

gen objetivo_8 = .
replace objetivo_8 = 814 if provincia_residencia == 1
replace objetivo_8 = 1984 if provincia_residencia == 2
replace objetivo_8 = 1661 if provincia_residencia == 3
replace objetivo_8 = 1011 if provincia_residencia == 4
replace objetivo_8 = 2460 if provincia_residencia == 5
replace objetivo_8 = 2063 if provincia_residencia == 6
replace objetivo_8 = 8290 if provincia_residencia == 7
replace objetivo_8 = 1440 if provincia_residencia == 8
replace objetivo_8 = 3402 if provincia_residencia == 9
replace objetivo_8 = 1093 if provincia_residencia == 10
replace objetivo_8 = 829 if provincia_residencia == 11
replace objetivo_8 = 1982 if provincia_residencia == 12
replace objetivo_8 = 1565 if provincia_residencia == 13

* Generar los porcentajes

forvalues i=1/8 {

gen dos_dosis_`i' = numero_2_`i' /objetivo_`i'*100
gen brecha_`i' = numero_1_`i'/objetivo_`i'*100
gen faltante_`i' = 100 - dos_dosis_`i' - brecha_`i'
}

* Formato
format dos_dosis_* brecha_* faltante_* %4.2f


forvalues i=1/8 {
graph hbar dos_dosis_`i' brecha_`i' faltante_`i', ///
over(provincia_residencia) stack ///
plotregion(fcolor(white)) ///
graphregion(fcolor(white)) ///
bgcolor("$mycolor2") ///
blabel(bar, position(inside) color(white)) ///
bar(1, color("$mycolor7")) ///
bar(2, color("$mycolor6")) ///
bar(3, color("$mycolor2")) ///
blabel(bar, size(vsmall) format(%4.1f)) ///
ytitle("Porcentaje (%)") ///
ylabel(0(20)100, nogrid) ///
legend(label(1 "Dos dosis") label(2 "Brecha entre primera y segunda dosis")  label(3 "Faltante") size(*0.8) region(col(white))) name(provincia_`i', replace)

graph export "figuras\vacunacion_provincial_edad_`i'.png", as(png) replace
graph export "figuras\vacunacion_provincial_edad_`i'.pdf", as(pdf) replace
}

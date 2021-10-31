use "${datos}\output\data_series_provincias_2021.dta", clear

drop if fecha_resultado < d(03jan2021)
gen semana = 1 if fecha_resultado >= d(03jan2021) & fecha_resultado <= d(09jan2021)
replace semana = semana[_n-7] + 1 if fecha > d(09jan2021)

collapse (max) total_positivo_* total_defuncion_*, by(semana)

* Mortalidad
gen mortalidad_1 = total_defuncion_1/28477*10000
gen mortalidad_2 = total_defuncion_2/57731*10000
gen mortalidad_3 = total_defuncion_3/76462*10000
gen mortalidad_4 = total_defuncion_4/40420*10000
gen mortalidad_5 = total_defuncion_5/105049*10000
gen mortalidad_6 = total_defuncion_6/84925*10000
gen mortalidad_7 = total_defuncion_7/463656*10000
gen mortalidad_8 = total_defuncion_8/71304*10000
gen mortalidad_9 = total_defuncion_9/185793*10000
gen mortalidad_10 = total_defuncion_10/31264*10000
gen mortalidad_11 = total_defuncion_11/52989*10000
gen mortalidad_12 = total_defuncion_12/92989*10000
gen mortalidad_13 = total_defuncion_13/66439*10000

* Incidencia
gen incidencia_1 = total_positivo_1/28477*10000
gen incidencia_2 = total_positivo_2/57731*10000
gen incidencia_3 = total_positivo_3/76462*10000
gen incidencia_4 = total_positivo_4/40420*10000
gen incidencia_5 = total_positivo_5/105049*10000
gen incidencia_6 = total_positivo_6/84925*10000
gen incidencia_7 = total_positivo_7/463656*10000
gen incidencia_8 = total_positivo_8/71304*10000
gen incidencia_9 = total_positivo_9/185793*10000
gen incidencia_10 = total_positivo_10/31264*10000
gen incidencia_11 = total_positivo_11/52989*10000
gen incidencia_12 = total_positivo_12/92989*10000
gen incidencia_13 = total_positivo_13/66439*10000
/*
* Generar el total de las provincias
gen defuncion = sum(defuncion_1 + defuncion_2 + defuncion_3+ defuncion_4+ defuncion_5+ defuncion_6+ defuncion_7+ defuncion_8+ defuncion_9+ defuncion_10+ defuncion_11 + defuncion_12+ defuncion_13)

gen positivo = sum(positivo_1 + positivo_2 + positivo_3 + positivo_4 + positivo_5 + positivo_6 + positivo_7 + positivo_8 + positivo_9 + positivo_10 + positivo_11 + positivo_12 + positivo_13)
*/
/*
gen total_defuncion =sum(defuncion)
gen total_positivo = sum(positivo)
x 

gen total_defuncion = sum(total_defuncion_1 + total_defuncion_2 + total_defuncion_3+ total_defuncion_4+ total_defuncion_5+ total_defuncion_6+ total_defuncion_7+ total_defuncion_8+ total_defuncion_9+ total_defuncion_10+ total_defuncion_11 + total_defuncion_12+ total_defuncion_13)

gen total_positivo = sum(total_positivo_1 + total_positivo_2 + total_positivo_3 + total_positivo_4 + total_positivo_5 + total_positivo_6 + total_positivo_7 + total_positivo_8 + total_positivo_9 + total_positivo_10 + total_positivo_11 + total_positivo_12 + total_positivo_13)
*/
/*
gen mortalidad = defuncion/1357075*1000000
gen incidencia = positivo/1357075*100000
*/

*keep fecha_resultado mortalidad* incidencia*


********************************************************************************
/*
* Mortalidad: Regional
* Colores
colorpalette ///
 "223  25   79" ///
 "79   67  	107" ///
 "102  98   125" ///
 "121  68  	83" ///
 "126  184  153" ///
 "233  217  210" ///
 "85   61  224" ///
  , n(7) nograph
  

twoway (line mortalidad fecha_resultado, lcolor("`r(p1)'") lwidth(medthick)) ///
if fecha_resultado >=d(01jan2021), ///
	ylabel(0(50)200, labsize(*0.6)) ///
	tlabel(01jan2021(45)$fecha) ///
	xtitle("Fecha", size(*0.7)) ///
	ytitle("Mortalidad (defunciones/población*100,000)") ///
	graphregion(color(white)) ///
	legend(off) ///
	title("2021", box bexpand bcolor("`r(p1)'") color(white))
	
gr export "figuras\mortalidad_regional_2021.png", as(png) replace
*gr export "figuras\mortalidad_regional_2021.eps", as(eps) replace
*!epstopdf "figuras\mortalidad_regional_2021.eps"

* Incidencia: regional
* Colores
colorpalette ///
 "223  25   79" ///
 "79   67  	107" ///
 "102  98   125" ///
 "121  68  	83" ///
 "126  184  153" ///
 "233  217  210" ///
 "85   61  224" ///
  , n(7) nograph
  

twoway (line incidencia fecha_resultado, lcolor("`r(p7)'") lwidth(medthick)) ///
if fecha_resultado >=d(01jan2021), ///
	ylabel(0(100)600, labsize(*0.6)) ///
	tlabel(01jan2021(45)$fecha) ///
	xtitle("Fecha", size(*0.7)) ///
	ytitle("Incidencia (casos/población*10,000)") ///
	graphregion(color(white)) ///
	legend(off) ///
	title("2021", box bexpand bcolor("`r(p7)'") color(white))
	
gr export "figuras\incidencia_regional_2021.png", as(png) replace
*gr export "figuras\incidencia_regional_2021.eps", as(eps) replace
*!epstopdf "figuras\incidencia_regional_2021.eps"

*/
********************************************************************************

label var mortalidad_1 "Acomayo"
label var mortalidad_2 "Anta"
label var mortalidad_3 "Calca"
label var mortalidad_4 "Canas"
label var mortalidad_5 "Canchis"
label var mortalidad_6 "Chumbivilcas"
label var mortalidad_7 "Cusco"
label var mortalidad_8 "Espinar"
label var mortalidad_9 "La Convención"
label var mortalidad_10 "Quispicanchi"
label var mortalidad_11 "Paruro"
label var mortalidad_12 "Paucartambo"
label var mortalidad_13 "Urubamba"


twoway (line mortalidad_1 semana, lcolor("$mycolor1") lwidth(medthick)) ///
(line mortalidad_2 semana, lcolor("$mycolor2") lwidth(medthick)) ///
(line mortalidad_3 semana, lcolor("$mycolor3") lwidth(medthick)) ///
(line mortalidad_4 semana, lcolor("$mycolor4") lwidth(medthick)) ///
(line mortalidad_5 semana, lcolor("$mycolor5") lwidth(medthick)) ///
(line mortalidad_6 semana, lcolor("$mycolor6") lwidth(medthick)) ///
(line mortalidad_7 semana, lcolor("$mycolor7") lwidth(medthick) lpattern(dash)) ///
(line mortalidad_8 semana, lcolor("$mycolor1") lwidth(medthick) lpattern(dash)) ///
(line mortalidad_9 semana, lcolor("$mycolor2") lwidth(medthick) lpattern(dash)) ///
(line mortalidad_10 semana, lcolor("$mycolor3") lwidth(medthick) lpattern(dash)) ///
(line mortalidad_11 semana, lcolor("$mycolor4") lwidth(medthick) lpattern(dash)) ///
(line mortalidad_12 semana, lcolor("$mycolor5") lwidth(medthick) lpattern(dash)) ///
(line mortalidad_13 semana, lcolor("$mycolor6") lwidth(medthick) lpattern(dash)) ///
if semana >=1, ///
	ylabel(0(5)30, labsize(*0.6) nogrid) ///
	tlabel(1(2)$semana) ///
	xtitle("Semana Epidemiológica", size(*0.7)) ///
	ytitle("Mortalidad (defunciones/población*10,000)") ///
	graphregion(color(white)) ///
	title("2021", box bexpand bcolor("$mycolor3") color(white)) ///
	legend(label(1 "Acomayo") label(2 "Anta") label(3 "Calca")  label(4 "Canas")  label(5 "Canchis") label(6 "Chumbivilcas")  label(7 "Cusco")  label(8 "Espinar") label(9 "La Convención") label(10 "Quispicanchi") label(11 "Paruro") label(12 "Paucartambo") label(13 "Urubamba") size(*0.75) ring(0) position(11) bmargin(large) color(gs1) c(1) region(col(white))) legend(size(tiny)) name(morta_prov, replace)

gr export "figuras\mortalidad_provincial_2021.png", as(png) replace
gr export "figuras\mortalidad_provincial_2021.pdf", as(pdf) replace

* Incidencia Pronvincial

twoway (line incidencia_1 semana, lcolor("$mycolor1") lwidth(medthick)) ///
(line incidencia_2 semana, lcolor("$mycolor2") lwidth(medthick)) ///
(line incidencia_3 semana, lcolor("$mycolor3") lwidth(medthick)) ///
(line incidencia_4 semana, lcolor("$mycolor4") lwidth(medthick)) ///
(line incidencia_5 semana, lcolor("$mycolor5") lwidth(medthick)) ///
(line incidencia_6 semana, lcolor("$mycolor6") lwidth(medthick)) ///
(line incidencia_7 semana, lcolor("$mycolor7") lwidth(medthick) lpattern(dash)) ///
(line incidencia_8 semana, lcolor("$mycolor1") lwidth(medthick) lpattern(dash)) ///
(line incidencia_9 semana, lcolor("$mycolor2") lwidth(medthick) lpattern(dash)) ///
(line incidencia_10 semana, lcolor("$mycolor3") lwidth(medthick) lpattern(dash)) ///
(line incidencia_11 semana, lcolor("$mycolor4") lwidth(medthick) lpattern(dash)) ///
(line incidencia_12 semana, lcolor("$mycolor5") lwidth(medthick) lpattern(dash)) ///
(line incidencia_13 semana, lcolor("$mycolor6") lwidth(medthick) lpattern(dash)) ///
if semana >=1, ///
	ylabel(0(100)800, labsize(*0.6) nogrid) ///
	tlabel(1(2)$semana) ///
	xtitle("Semana Epidemiológica", size(*0.7)) ///
	ytitle("Incidencia (casos/población*10,000)") ///
	graphregion(color(white)) ///
	title("2021", box bexpand bcolor("$mycolor3") color(white)) ///
	legend(label(1 "Acomayo") label(2 "Anta") label(3 "Calca")  label(4 "Canas")  label(5 "Canchis") label(6 "Chumbivilcas")  label(7 "Cusco")  label(8 "Espinar") label(9 "La Convención") label(10 "Quispicanchi") label(11 "Paruro") label(12 "Paucartambo") label(13 "Urubamba") size(*0.75) ring(0) position(11) bmargin(large) color(gs1) c(1) region(col(white))) legend(size(tiny)) name(inci_provi, replace)
	
gr export "figuras\incidencia_provincial_2021.png", as(png) replace
gr export "figuras\incidencia_provincial_2021.pdf", as(pdf) replace

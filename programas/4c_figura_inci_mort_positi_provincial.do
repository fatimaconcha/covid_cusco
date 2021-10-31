*-------------------------------------------------------------------------------%

* Programa: Generar Figuras a Nivel Provincial

* Primera vez creado:     06 de junio del 2021
* Ultima actualizaciónb:  06 de junio del 2021

*-------------------------------------------------------------------------------%

use "${datos}/output/serie_semanal_provincias.dta", clear

forvalues i=1/13 {

********************************************************************************
* Incidencia y Mortalidad por Provincias
********************************************************************************

* 2020
twoway (line mortalidad_`i' semana, yaxis(1) ylabel(0(0.5)2) yscale(range(0(0.5)3) axis(1)) lcolor("$mycolor2")) ///
(line incidencia_`i' semana, lcolor("$mycolor6") yaxis(2) yscale(axis(2) off) ylabel(0(10)60, axis(2))) ///
if semana >=11 & semana<=53, ///
	tlabel(1(4)53) ///
	xtitle("Semanas Epidemológicas", size(*0.7)) ///
	graphregion(color(white)) ///
	legend(label(1 "Mortalidad") label(2 "Incidencia") size(*0.75) region(col(white))) ///
	title("2020", box bexpand bcolor("$mycolor3") color(white)) ///
	bgcolor(white) ///
	ylabel(, nogrid) ///	
	name(figura20_`i', replace)

* 2021
twoway (line mortalidad_`i' semana_2, yaxis(1) ylabel(0(0.5)2) yscale(range(0(0.5)3) axis(1) off) lcolor("$mycolor2")) ///
(line incidencia_`i' semana_2, lcolor("$mycolor6") yaxis(2) yscale(axis(2)) ylabel(0(10)60, axis(2))) ///
if semana_2 >=1 & semana_2<=$semana, ///
	tlabel(1(4)53) ///
	xtitle("Semanas Epidemológicas", size(*0.7)) ///
	graphregion(color(white)) ///
	legend(label(1 "Mortalidad") label(2 "Incidencia") size(*0.75) region(col(white))) ///
	title("2021", box bexpand bcolor("$mycolor3") color(white)) ///
	bgcolor(white) ///
	ylabel(, nogrid) ///	
	name(figura21_`i', replace)


* Combinamos ambas gráficas (2020 y 2021)
graph combine figura20_`i' figura21_`i', ///
graphregion(color(white)) ///
name(figura_20_21_`i', replace)

gr export "figuras\incidencia_mortalidad_20_21_`i'.png", as(png) replace
gr export "figuras\incidencia_mortalidad_20_21_`i'.pdf", as(pdf) name("figura_20_21_`i'") replace

********************************************************************************
* Tasa de Positividad PCR y AG por Provincias
********************************************************************************
*2020
twoway (line positividad_pcr_`i' semana, lcolor("$mycolor5") lpattern(shortdash) ) ///
(line positividad_ag_`i' semana,  lcolor("`r(p3)'")  lpattern(shortdash) ) ///
if semana >=11 & semana <=53, ///
	tlabel(1(4)53) ///
	ylabel(0(20)100) ///
	xtitle("Semanas Epidemológicas", size(*0.7)) ///
	ytitle("Tasa de Positividad") ///
	graphregion(color(white)) ///
	legend(label(1 "Molecular") label(2 "Antigénica") size(*0.75) region(col(white))) ///
	title("2020", box bexpand bcolor("$mycolor3") color(white)) ///
	bgcolor(white) ///
	ylabel(, nogrid) ///	
	name(positividad20_`i', replace)

* 2021
twoway (line positividad_pcr_`i' semana_2, lcolor("$mycolor5")  lpattern(shortdash)) ///
(line positividad_ag_`i' semana_2,  lcolor("$mycolor3")  lpattern(shortdash)) ///
if semana_2 >=1 & semana_2<=$semana, ///
	tlabel(1(4)53) ///
	ylabel(0(20)100) ///
	xtitle("Semanas Epidemológicas", size(*0.7)) ///
	ytitle("Tasa de Positividad") ///
	graphregion(color(white)) ///
	legend(label(1 "Molecular") label(2 "Antigénica") size(*0.75) region(col(white))) ///
	title("2021", box bexpand bcolor("$mycolor3") color(white)) ///
	bgcolor(white) ///
	ylabel(, nogrid) ///	
	name(positividad21_`i', replace)

* Combinar y guardar las figuras
graph combine positividad20_`i' positividad21_`i', ///
graphregion(color(white)) ///
name(positividad_20_21_`i', replace)

gr export "figuras\positividad_20_21_`i'.png", as(png) replace
gr export "figuras\positividad_20_21_`i'.pdf", as(pdf) name("positividad_20_21_`i'") replace

}

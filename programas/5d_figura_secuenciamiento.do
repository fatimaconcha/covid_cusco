use "${datos}\output\datos_variantes", clear

forvalues i=1/5{
preserve
keep if variante == `i'
collapse (count) dni, by(mes)
rename dni variante_`i'
save "${datos}\temporal\datos_variantes_`i'", replace
restore
}

use "${datos}\temporal\datos_variantes_1", clear
merge 1:1 mes using "${datos}\temporal\datos_variantes_2", nogen
merge 1:1 mes using "${datos}\temporal\datos_variantes_3", nogen
merge 1:1 mes using "${datos}\temporal\datos_variantes_4", nogen
merge 1:1 mes using "${datos}\temporal\datos_variantes_5", nogen

*save "datos\output\datos_variante_lab_cayetano", replace

*use "datos\output\datos_variante_lab_cayetano", clear

recode * (.=0)

gen suma = variante_1 + variante_2+variante_3+variante_4 
gen suma_total = variante_1 + variante_2+variante_3+variante_4 + variante_5


gen lambda = variante_1/suma
gen gamma = variante_2/suma
gen delta = variante_3/suma
gen otros = variante_4/suma
*gen ninguno = variante_5/suma

replace mes = mes + 731
format mes %tm


format lambda gamma delta otros %8.2f
label var suma_total "Número de Sepas Secuenciadas"

* Definimos nuestra paleta

twoway (line lambda mes, yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) lcolor("$mycolor2")) ///
(scatter lambda mes, msize(vsmall) mcolor("$mycolor2") mlabel(lambda) mlabcolor("$mycolor2") mlabsize(vsmall) connect()) ///
(line gamma mes, yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) lcolor("$mycolor3")) ///
(scatter gamma mes, msize(vsmall) mcolor("$mycolor3") mlabel(gamma) mlabcolor("$mycolor3") mlabsize(vsmall) connect()) ///
(line delta mes, yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) lcolor("$mycolor4")) ///
(scatter delta mes, msize(vsmall) mcolor("$mycolor4") mlabel(delta) mlabcolor("$mycolor4") mlabsize(vsmall) connect()) ///
(line otros mes, yaxis(1) ylabel(0(0.2)1) yscale(range(0(0.2)1) axis(1)) lcolor("$mycolor5")) ///
(scatter otros mes, msize(vsmall) mcolor("$mycolor5") mlabel(otros) mlabcolor("$mycolor5") mlabsize(vsmall) connect()) ///
(line suma_total mes, lcolor("$mycolor6") lwidth(thick) yaxis(2) yscale(axis(2)) ylabel(0(40)120, axis(2))) ///
(scatter suma_total mes, msize(vsmall) mcolor("$mycolor6") mlabel(suma_total) mlabposition(12) mlabcolor("$mycolor6") mlabsize(vsmall) connect() yaxis(2) yscale(axis(2)) ylabel(0(40)120, axis(2))) ///
 ,	xtitle("Mes", size(*0.7)) ///
 ytitle("Porcentaje de las Variantes Econtradas", size(*0.7)) ///
	graphregion(color(white)) ///
	xlabel(735 "Abril" 736 "Mayo" 737 "Junio" 738 "Julio" 739 "Agosto" 740 "Septiembre" 741 "Octubre") ///
	legend(cols(3) label(1 "Lambda") label(2 "") label(3 "Gamma") label(4 "") label(5 "Delta") label(6 "") label(7 "Otros") label(8 "") label(9 "Tota de Muestra") label(10 "") order(9 1 3 5 7) size(*0.75) region(col(white))) ///
	title("Variantes en la Región Cusco", box bexpand bcolor("$mycolor3") color(white)) ///
	bgcolor(white) ///
	ylabel(, nogrid) name(variantes, replace)
	
gr export "figuras\variantes.png", as(png) replace
gr export "figuras\variantes.pdf", as(pdf) replace

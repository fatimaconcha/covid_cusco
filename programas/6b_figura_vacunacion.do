
use "${datos}\output\base_vacunados", clear

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

* Contar cuántos son
* IMPORTANTE: Las personas con tres dosis se cuentan en personas con dos dosis
*replace dosis = 2 if dosis == 3

preserve 
gen numero = _n
collapse (count) numero if dosis == 1, by(grupo_edad)
rename numero uno
save "${datos}\temporal\vacunados_primera", replace
restore 

preserve 
gen numero = _n
collapse (count) numero if dosis == 2, by(grupo_edad)
rename numero dos
save "${datos}\temporal\vacunados_segunda", replace
restore

/*
preserve 
gen numero = _n
collapse (count) numero if dosis == 3, by(grupo_edad)
rename numero tres
save "datos\temporal\vacunados_tercera", replace
restore 
*/

use "${datos}\temporal\vacunados_primera", clear
merge 1:1 grupo_edad using "${datos}\temporal\vacunados_segunda", nogen
**merge 1:1 grupo_edad using "datos\temporal\vacunados_tercera", nogen

gen objetivo = .
replace objetivo = 209028 if grupo_edad == 1
replace objetivo = 264050 if grupo_edad == 2
replace objetivo = 224035 if grupo_edad == 3
replace objetivo = 182192 if grupo_edad == 4
replace objetivo = 139854 if grupo_edad == 5
replace objetivo = 92209 if grupo_edad == 6
replace objetivo = 51864 if grupo_edad == 7
replace objetivo = 28594 if grupo_edad == 8

gen dos_dosis = dos/objetivo*100
gen brecha_primera_segunda = uno/objetivo*100
*gen tres_dosis = tres/objetivo*100
*gen faltante = 100 - dos_dosis - brecha_primera_segunda - tres_dosis
gen faltante = 100 - dos_dosis - brecha_primera_segunda

*format dos_dosis brecha_primera_segunda tres_dosis faltante %4.1f
format dos_dosis brecha_primera_segunda faltante %4.1f

* Gráfica
graph hbar dos_dosis brecha_primera_segunda faltante, ///
over(grupo_edad) stack ///
plotregion(fcolor(white)) ///
graphregion(fcolor(white)) ///
bgcolor("$mycolor3") ///
blabel(bar, position(inside) color(white)) ///
bar(1, color("$mycolor3")) ///
bar(2, color("$mycolor4")) ///
bar(3, color("$mycolor2")) ///
blabel(bar, size(vsmall) format(%4.1f)) ///
ytitle("Porcentaje (%)") ///
ylabel(0(20)100, nogrid) ///
legend(label(1 "Dos dosis") label(2 "Brecha entre primera y segunda dosis") label(3 "No Vacunados") size(*0.8) region(col(white))) name(vacunacion_grupo_edad, replace)


/*
graph hbar dos_dosis brecha_primera_segunda tres_dosis faltante, ///
over(grupo_edad) stack ///
plotregion(fcolor(white)) ///
graphregion(fcolor(white)) ///
bgcolor("$mycolor3") ///
blabel(bar, position(outside) color(black)) ///
bar(1, color("$mycolor3")) ///
bar(2, color("$mycolor4")) ///
bar(3, color("$mycolor1")) ///
bar(4, color("$mycolor2")) ///
blabel(bar, size(vsmall) format(%4.1f)) ///
ytitle("Porcentaje (%)") ///
ylabel(0(20)100, nogrid) ///
legend(label(1 "Dos dosis") label(2 "Brecha entre primera y segunda dosis") label(3 "Tres dosis") label(4 "No Vacunados") size(*0.8) region(col(white))) name(vacunacion_grupo_edad, replace)
*/
* Exportar figura
graph export "figuras\vacunacion_grupo_edad.png", as(png) replace
graph export "figuras\vacunacion_grupo_edad.pdf", as(pdf) replace

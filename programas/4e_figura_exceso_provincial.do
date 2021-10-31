********************************************************************************
* Cargar las bases de datos
********************************************************************************

* 2019
use "${datos}\output\defunciones_totales_provincial_2019.dta", clear

* Juntar con el 2020
merge 1:1 semana using "${datos}\output\defunciones_totales_provincias_2020_2021.dta", nogen

* Eliminar la semana mayor a 53
drop if semana > 53

* Generar los excesos para cada semana epidemiológica y para cada provincia
forvalues t=1/13 {
gen exceso_`t' = d21_`t' - d19_`t'
sum exceso_`t' if semana == $semana
local exceso_prov_`t' = r(mean)
}

********************************************************************************
* Generar las Figuras con un loop
********************************************************************************
forvalues i=1/13 {

* 2020

* Establecer el máximo del 2021 para la magnitud del eje de las "y".
* Además, generar un quinto de esas divisiones para las referencias del eje "y"
* Además, generar un medio para colocar la etiqueta "Excesp SE" en la figura de acuedo a cada magnitud "y"

egen var_max_`i'=rowmax(d20_`i' d21_`i')
sum var_max_`i'
local maximo = r(max)
local division = r(max)/5
local posicion = r(max)/2

* Colores

* Graficamos
twoway (line d19_`i' semana, lcolor("$mycolor3")) ///
(line d20_`i' semana, lcolor("$mycolor2")) ///
if semana>=1 & semana <=53 ///
  ,xtitle("Semanas Epidemológicas", size(*0.9)) 				///
  xlabel(1(4)53, labsize(*0.8)) ///
  ylabel(0(`division')`maximo', labsize(*0.8)) ///
  graphregion(color(white)) ///
  name(p20_`i', replace) ///
  legend(label(1 "2019") label(2 "2020") size(*0.6) region(col(white))) ///
  title("2020", box bexpand bcolor("$mycolor3") color(white)) ///
  bgcolor(white) xlabel(, nogrid) ylabel(, nogrid) 

* 2021

* Graficamos 
twoway (line d19_`i' semana, lcolor("$mycolor3")) ///
(line d21_`i' semana, lcolor("$mycolor2")) ///
if semana>=1 & semana <=$semana ///
  ,xtitle("Semanas Epidemológicas", size(*0.9)) 				///
  xlabel(1(4)53, labsize(*0.8)) ///
  ylabel(0(`division')`maximo', labsize(*0.8)) ///
  graphregion(color(white)) ///
  name(p21_`i', replace) ///
  legend(label(1 "2019") label(2 "2021") size(*0.6) region(col(white))) ///
  title("2021", box bexpand bcolor("$mycolor3") color(white)) ///
  bgcolor(white) xlabel(, nogrid) ylabel(, nogrid) ///
  text(`posicion' $semana "{it:Exceso SE$semana: `exceso_prov_`i''}", place(se) box just(left) margin(l+1 t+1 b+1) width(23) size(small) color(white) bcolor("$mycolor2") fcolor("$mycolor2"))

* Combinamos los gráficos
graph combine p20_`i' p21_`i', ///
graphregion(color(white)) ///
name(exceso_`i', replace)

* Guardamos en el formato requerido
gr export "figuras\exceso_`i'.png", as(png) replace
gr export "figuras\exceso_`i'.pdf", as(pdf) name(exceso_`i') replace
}

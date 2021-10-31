
use "${datos}\output\data_boletin.dta", clear

sum sin_fiebre_2 
mat sintoma_1 =r(N)

sum sin_malestar
mat sintoma_2 =r(N)

sum sin_tos
mat sintoma_3 =r(N)

sum sin_garganta
mat sintoma_4 =r(N)

sum sin_congestion
mat sintoma_5 =r(N)

*sum sin_respiratoria
*mat sintoma_6 =r(N)

sum sin_diarrea
mat sintoma_7 =r(N)

sum sin_nauseas
mat sintoma_8 =r(N)

sum sin_cefalea
mat sintoma_9 =r(N)

sum sin_irritabilidad
mat sintoma_10 =r(N)

sum sin_muscular
mat sintoma_11 =r(N)

sum sin_abdominal
mat sintoma_12 =r(N)

sum sin_pecho
mat sintoma_13 =r(N)

sum sin_articulaciones
mat sintoma_14 =r(N)

sum sin_otro 
mat sintoma_15 =r(N)

* Alinear todos los resultados para crear una tabla
*mat all = (sintoma_1 \ sintoma_2 \ sintoma_3 \ sintoma_4 \ sintoma_5 \ sintoma_6 \ sintoma_7 \ sintoma_8 \ sintoma_9 \ sintoma_10 \ sintoma_11 \ sintoma_12 \ sintoma_13 \ sintoma_14 \ sintoma_15)

mat all = (sintoma_1 \ sintoma_2 \ sintoma_3 \ sintoma_4 \ sintoma_5 \ sintoma_7 \ sintoma_8 \ sintoma_9 \ sintoma_10 \ sintoma_11 \ sintoma_12 \ sintoma_13 \ sintoma_14 \ sintoma_15)

* Nombrar la tabla
matrix colnames all = "Frecuencia"
matrix rownames all = "Fiebre" "Malestar" "Tos" "Dolor de garganta" "Congestion" "Diarrea" "Nauseas" "Cefalea" "Irritabilidad" "Dolor Muscular" "Dolor Abdominal" "Dolor de Pecho" "Dolor Articular" "Otro"

* Exportar la tabla
esttab matrix(all) using "${datos}\output\tabla_sintoma.csv", replace wide plain label fragment nonumbers nomtitles scsv

****************************
* Figura de los Sintomáticos

* Importar la data
import delimited "${datos}\output\tabla_sintoma.csv", clear

* Renombrar la primera variable
rename v1 sintoma

* Calcular el número máximo de sintomas por cualquier síntoma
sum frecuencia 
local total = r(mean)*r(N)
* Frecuencia relativa
gen porcentaje = 100*frecuencia/`total'

graph hbar porcentaje, over(sintoma, sort(porcentaje) descending) graphregion(color(white)) ///
blabel(bar, format(%4.1f)) bar(1, fcolor("$mycolor2") lcolor("$mycolor2") ) ///
ytitle("% de Pacientes con al menos el síntoma") ///
bgcolor(white) ///
ylabel(, nogrid)

graph export "figuras\figura_sintoma.png", as(png) name("Graph") replace
graph export "figuras\figura_sintoma.pdf", as(pdf) name("Graph") replace

********************************************************************************
use "${datos}\output\data_boletin.dta", clear

* Comorbilidad
sum com_obesidad
mat comorbilidad_1 = r(N)

sum com_pulmonar
mat comorbilidad_2 = r(N)

sum com_diabetes
mat comorbilidad_3 = r(N)

sum com_cardiovasular
mat comorbilidad_4 = r(N)

sum com_inmunodeficiencia
mat comorbilidad_5 = r(N)

sum com_cancer
mat comorbilidad_6 = r(N)

sum com_embarazo
mat comorbilidad_7 = r(N)

sum com_asma
mat comorbilidad_8 = r(N)

sum com_renal
mat comorbilidad_9 = r(N)

sum com_ninguno
mat comorbilidad_10 = r(N)

* Alinear todos los resultados para crear una tabla
mat all = (comorbilidad_1 \ comorbilidad_2 \ comorbilidad_3 \ comorbilidad_4 \ comorbilidad_5 \ comorbilidad_6 \ comorbilidad_7 \ comorbilidad_8 \ comorbilidad_9 \ comorbilidad_10)

* Nombrar la tabla
matrix colnames all = "Frecuencia"
matrix rownames all = "Obesidad" "Pulmonar" "Diabetes" "Cardiovascular" "Inmunodeficiencia" "Cancer" "Embarazo" "Asma" "Renal" "Ninguno"

* Exportar la tabla
esttab matrix(all) using "datos\output\tabla_comorbilidad.csv", replace wide plain label fragment nonumbers nomtitles scsv

****************************
* Figura de los Sintomáticos

import delimited "${datos}\output\tabla_comorbilidad.csv", clear

* Nombrar la variable
rename v1 comorbilidad

* Borrar los que no tienen ninguna comorbilidad
drop if comorbilidad == "Ninguno"

* Calcular la frecuencia relativa
sum frecuencia 
local total = r(mean)*r(N)
gen porcentaje = 100*frecuencia/`total'

graph hbar porcentaje, over(comorbilidad, sort(porcentaje) descending) graphregion(color(white)) ///
blabel(bar, format(%4.1f)) bar(1, fcolor("$mycolor3") lcolor("$mycolor3")) ///
ytitle("% de Pacientes con al menos la comorbilidad") ///
bgcolor(white) ///
ylabel(, nogrid)

graph export "figuras\figura_comorbilidad.png", as(png) name("Graph") replace
graph export "figuras\figura_comorbilidad.pdf", as(pdf) name("Graph") replace


******************************************************************************** 
* Signos
use "${datos}\output\data_boletin.dta", clear

sum sig_exudado 
mat signo_1 = r(N)

sum sig_conjuntival
mat signo_2 = r(N)

sum sig_convulsion
mat signo_3 = r(N)

*sum sig_coma
*mat signo_4 = r(N)

sum sig_disnea
mat signo_4 = r(N)

*sum sig_auscultacion
*mat signo_6 = r(N)

*sum sig_rxpulmonar 
*mat signo_7 = r(N)

* Alinear todos los resultados para crear una tabla
*mat all = (signo_1 \ signo_2 \ signo_3 \ signo_4 \ signo_5 \ signo_7)
mat all = (signo_1 \ signo_2 \ signo_3 \ signo_4 )

* Nombrar la tabla
matrix colnames all = "Frecuencia"
*matrix rownames all = "Exudado Faringeo" "Inyeccion Conjuntival" "Convulsion" "Coma" "Disnea" "Auscultacion" "Radiografia pulmonar alterada"
matrix rownames all = "Exudado Faringeo" "Inyeccion Conjuntival" "Convulsion" "Disnea"


* Exportar la tabla
esttab matrix(all) using "datos\output\tabla_signos.csv", replace wide plain label fragment nonumbers nomtitles scsv

****************************
* Figura

import delimited "datos\output\tabla_signos.csv", clear

* Nombrar la variable
rename v1 signo

* Borrar los que no tienen ninguna comorbilidad
*drop if comorbilidad == "Ninguno"

* Calcular la frecuencia relativa
sum frecuencia 
local total = r(mean)*r(N)
gen porcentaje = 100*frecuencia/`total'
  
graph hbar porcentaje, over(signo, sort(porcentaje) descending) graphregion(color(white)) ///
blabel(bar, format(%4.1f)) bar(1, fcolor("$mycolor4") lcolor("$mycolor4")) ///
ytitle("% de Pacientes con al menos un signo") ///
bgcolor(white) ///
ylabel(, nogrid)

graph export "figuras\figura_signo.png", as(png) name("Graph") replace
graph export "figuras\figura_signo.pdf", as(pdf) name("Graph") replace

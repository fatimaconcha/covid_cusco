*-------------------------------------------------------------------------------%

* Programa: Datos a Nivel Regional por Semana Epidemiológicas

* Primera vez creado:     06 de junio del 2021
* Ultima actualizaciónb:  06 de junio del 2021

*-------------------------------------------------------------------------------%

********************************************************************************

* Cargar los datos
use "${datos}\output\data_series_region.dta", replace

* Generar la cantidad de asintomáticos diaria
gen asintomatico = positivo - sintomatico

* Generar las semanas epidemiológicas
gen semana = .
replace semana = 11 if fecha == 21987 | fecha == 21988
replace semana = 12 if fecha > 21988 & fecha <= 21995
replace semana = semana[_n-7] + 1 if fecha > 21995

* Contar las variables por semana epidemiológica
collapse (sum) positivo positivo_pcr positivo_pr positivo_ag prueba prueba_pcr prueba_pr prueba_ag recuperado sintomatico asintomatico sintomatico_pcr sintomatico_ag sintomatico_pr defuncion, by(semana)

* Eliminar datos más de la semana actual, la variable global "$semana", + 53 porque son 53 semanas del año 2020
drop if semana > $semana +53

* Generar la tasa de crecimiento semanal de los casos y defunciones
foreach var of varlist positivo defuncion {
gen `var'_d = (`var'-`var'[_n-1])/`var'*100
}

* Declarar serie de tiempo a la variable "semana"
tsset semana

* Generar la semana epidemiológica del 2021
gen numero = _n
gen semana_2 = .
replace semana_2 = semana - 53
replace semana_2 = . if semana_2 < 0

* Generar la tasa de positividad semanal: casos semanales por tipo de prueba / numero de positivos y negativos por tipo de prueba x 100
gen positividad_pcr = positivo_pcr/prueba_pcr*100
gen positividad_ag = positivo_ag/prueba_ag*100
*gen positividad_pr = positivo_pr/prueba_pr*100

* Etiquetar las variables
label var semana "Semana Epidemiológica"
label var semana_2 "Semana Epidemiológica"
label var defuncion "Defunciones por COVID-19"
label var defuncion_d "% Crecimiento de Defunciones"
label var positivo "Casos Positivos"
label var positivo_d "% Crecimiento de Casos"
label var sintomatico "Sintomáticos"
label var asintomatico "Asintomáticos"
label var sintomatico_pcr "Sintompaticos PCR"
label var sintomatico_pr_sis "Sintomatico PR"
label var sintomatico_ag "Sintomatico AG"

* Definir los formatos de las variables, con comas y como porcentajes
format positivo sintomatico asintomatico %11.0gc
format defuncion_d positivo_d positividad_pcr positividad_ag %8.1f
recode sintomatico_ag (0=.) if semana <=53

* Guardar la base de datos generada con todos los cambios
save "${datos}\output\serie_semanal_region.dta", replace
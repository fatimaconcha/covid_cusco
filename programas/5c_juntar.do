
* Ver clasificación:
* https://www.who.int/es/activities/tracking-SARS-CoV-2-variants

use "${datos}\temporal\datos_secuenciamiento_netlab", clear

append using "${datos}\temporal\datos_secuenciamiento_upch"

destring dni, replace force
replace dni = _n if dni == .

sort dni
duplicates report dni
duplicates tag dni, gen(dupli_noti)
quietly by dni: gen dup_noti = cond(_N==1,0,_n)
*br dni dupli_noti dup_noti if dup_noti != 0
*drop if dni == 77920619 & linaje == " -"
duplicates drop dni, force

* Para facilitar el código
split linaje

replace linaje1 = linaje2 if linaje1 == "Linaje" 

*drop if linaje1 == "pendiente" | linaje1 == "Pendiente"

gen variante = .
replace variante = 1 if linaje1 == "C.37" | linaje1 == "C.37.1" | linaje1 == "C.37 "
replace variante = 2 if linaje1 == "P-1" | linaje1 == "P.1" | linaje1 == "P.1.12" | linaje1 == "P.1.7" | linaje1 == "P.1 " 
replace variante = 3 if linaje1 == "AY.12" | linaje1 == "AY.20" | linaje1 == "AY.20 " | linaje1 == "AY.4" | linaje1 == "B.1.617.2" | linaje1 == "B.1.617.2 " | linaje1 == "AY.25" | linaje1 == "AY.39"
replace variante = 4 if linaje1 == "B.1.621" | linaje1 == "L.B.348"
replace variante = 5 if linaje1 == "observacion"
label define variante 1 "lambda" 2 "gamma" 3 "delta" 4 "otro" 5 "observacion"
label values variante variante
tab variante

keep dni mes variante muestra

save "${datos}\output\datos_variantes", replace


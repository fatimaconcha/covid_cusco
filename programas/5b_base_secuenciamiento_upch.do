* Importar la base
import excel "${datos}\raw\base_secuenciamiento_cayetano.xlsx", sheet("#1 Mayo") firstrow clear

* Borrar los que no tienen secuencia
drop if PANGO_lineage == "" | PANGO_lineage == "-"

rename D dni

save "${datos}\temporal\base_upch_mayo", replace

import excel "${datos}\raw\base_secuenciamiento_cayetano.xlsx", sheet("#2 Junio") firstrow clear

* Borrar los que no tienen secuencia
drop if PANGO_lineage == "" | PANGO_lineage == "-"

rename D dni

save "${datos}\temporal\base_upch_junio", replace

import excel "${datos}\raw\base_secuenciamiento_cayetano.xlsx", sheet("#3 Setiembre") firstrow clear

* Borrar los que no tienen secuencia
drop if PANGO_lineage == "" | PANGO_lineage == "-"

rename C dni

save "${datos}\temporal\base_upch_setiembre", replace

append using "${datos}\temporal\base_upch_mayo", force
append using "${datos}\temporal\base_upch_junio", force


* Reportar duplicados
sort codigo
duplicates report codigo

* Generar las variables de interés
*tab linaje

gen linaje = PANGO_lineage

*tab OMS_variante
/*
gen variante = 1 if OMS_variante == "Delta"
replace variante = 2 if OMS_variante == "Gamma"
replace variante = 3 if OMS_variante == "Lambda"
label var variante "Variante COVID"
label define variante 1 "delta" 2 "gamma" 3 "lambda"
label values variante variante

tab variante
*/
* Fecha
rename fechacolecta fecha_upch
format fecha_upch %td
gen mes = month(fecha_upch)

* edad
rename ciudadcolección distrito

keep codigo fecha_upch linaje edad mes distrito sexo dni 

* Eliminamos los que no tienen niguna variante
*drop if variante == .


* Distrito

replace distrito = "SAN SEBASTIAN" if distrito == "CORAO"

* Borrar la observación que proviene de Curahuasi
drop if distrito == "CURAHUASI"

gen muestra = "cayetano"

drop if mes == .
save "${datos}\temporal\datos_secuenciamiento_upch", replace

* Cargar la base de datos
use "${datos}/output/base_covid.dta", clear

* Mantener sólo a los positivos por los trés tipos de pruebas
keep if positivo_molecular == 1 | positivo_rapida == 1 | positivo_antigenica == 1 

* Generar nueva fecha que sólo incluya las últimas cuatro semanas
gen fecha_mapa_4_semanas = .
replace fecha_mapa_4_semanas = fecha_resultado if fecha_resultado >= d($fecha) - 28

sort fecha_mapa_4_semanas
*br fecha_mapa_4_semanas fecha_resultado if fecha_mapa_4_semanas != .
drop if fecha_mapa_4_semanas == .

* Generar la variable tipo
gen tipo = .
replace tipo = 1 if positivo_rapida == 1
replace tipo = 2 if positivo_molecular == 1
replace tipo = 3 if positivo_antigenica == 1

* Ordenar por tipo
sort tipo

* Borrar los que no son positivos
drop if tipo == .

* Mantener solo las variables que irán en el mapa
keep dni direccion departamento provincia distrito latitud longitud tipo_prueba sexo edad fecha_resultado tipo

* Eliminar los acentos 
replace direccion = ustrlower(ustrregexra(ustrnormalize( direccion, "nfd" ) , "\p{Mark}", "" ))

* Guardar la base
*save "datos/output/data_mapa.dta", replace

* Exportar la base en excel para enviar
export excel using "${datos}/output/data_mapa_$fecha.xlsx", firstrow(variables) replace
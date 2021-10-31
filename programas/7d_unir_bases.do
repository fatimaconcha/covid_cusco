
use "${datos}\output\data_noti_boletin.dta", clear

append using "${datos}\output\data_sis_pr_boletin.dta"
append using "${datos}\output\data_sis_ag_boletin.dta"

save "${datos}\output\data_boletin.dta", replace
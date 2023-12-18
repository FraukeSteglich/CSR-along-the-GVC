********************************************************************************
*** Herkenhoff, Krautheim, Semrau and Steglich
* Corporate Social Responsibility along the Global Value Chain

* Do-file name: 10_CSR_summary_statistics.do
* Authors: Finn Ole Semrau, Frauke Steglich
	
*******************************
** industry upstremaness Top 15	
**** with WIOD industry classification
use "${data_path_prep}Total_merged_main_reg.dta", clear
keep if sample_cr == 1
duplicates drop year ISIC_IndustryCode UiIND, force

tabstat UiIND , by(ISIC_IndustryDesc) statistics(mean sd min max) save

	return list // shows how matrix is saved

capture erase "${results_path}Table_1.xlsx" // verify that the excel sheet is empty at the beginning
	putexcel set "${results_path}Table_1.xlsx", replace

	putexcel A1 = "ISIC-4 Industry" B1 = "mean" C1 = "sd" D1 = "min" E1 = "max"	
	foreach i of numlist 1/34 {
		local j = `i' + 1
		putexcel A`j' = "`r(name`i')'"
		putexcel B`j' = matrix(r(Stat`i')') ,  nformat(number_d2)
				}
	local j = `j' + 1
		putexcel A`j' = "Across all industries"
		putexcel B`j' = matrix(r(StatTotal)') ,  nformat(number_d2)
				

				
*************** Summary stats: Table 1
use "${data_path_prep}Total_merged_main_reg.dta", clear
	
// based on broadest sample

log using "${log_path}sum_stat", replace name(sum_stat)

sum CSR_staff_social if sample_cr == 1
sum l_CSR_staff_social if sample_cr == 1
sum UiIND_weighted if sample_cr == 1
sum OECD_exp_exp_sh_weigh if sample_cr == 1
sum l_comp_h_weigh if sample_cr == 1
sum export_share if sample_cr == 1
sum domestic_inputs_sh if sample_cr == 1
sum SOE if sample_cr == 1
sum foreign if sample_cr == 1
sum l_sa_sales if sample_cr == 1
sum l_age if sample_cr == 1
sum nbr_products if sample_cr == 1
sum nbr_GVCIND if sample_cr == 1

cap log close sum_stat


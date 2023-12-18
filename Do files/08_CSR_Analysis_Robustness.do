********************************************************************************
*** Herkenhoff, Krautheim, Semrau and Steglich
* Corporate Social Responsibility along the Global Value Chain

*** Generates the output of robustness specifications
* Do-file name: 08_CSR_Analysis_Robustness.do
* Authors: Finn Ole Semrau, Frauke Steglich
	

********************************************************************************

********************************************************************************
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~* 
	Robustness Section 3.4
		3.4.1 Firms' Visibility to Final Consumers
		3.4.2 CSR as Share of Expenditure
		3.4.3 Labor Intensity
		3.4.4 Smoothed CSR Spending
		3.4.5 Inverse Hyperbolic Sine Transformation
		3.4.6 Shocks to Upstreamness
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/


*************************************************
**** 3.4.1 Firms' Visibility to Final Consumers
*************************************************	
use "${data_path_prep}Total_merged_main_reg.dta", clear

	sort co_code year	
	xtset co_code year

	global l1x1	"c.l1.OECD_exp_exp_sh_weigh c.l1.l_comp_h_weigh c.l1.export_share c.l1.domestic_inputs_sh i.l1.SOE i.l1.foreign c.l1.l_sa_sales c.l1.l_age c.l1.l_sellingexp " 

*** Cross section
	* level	
	reghdfe l_CSR_staff_social c.l1.UiIND_weighted $l1x1, a(i.nic_industry##i.year i.state_code ) vce(cluster co_code) 
	outreg2 using "${results_path}Table_5.tex", replace addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes) addstat("Number of clusters", e(N_clust), "R2", e(r2), "adjusted R2", e(r2_a)) ctitle((ln) CSR, OLS, cross section)  dec(3) lab nocons  tex keep(l_CSR_staff_social c.l1.UiIND_weighted $l1x1 )
		
	
	* ppmlhdfe without zeros
	ppmlhdfe CSR_staff_social c.l1.UiIND_weighted $l1x1  if CSR_staff_social!=0, a(i.nic_industry##i.year i.state_code) vce(cluster co_code)
	outreg2 using "${results_path}Table_5.tex", append addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes)  ctitle(CSR in USD, ppml, cross section) addstat( "Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) dec(3) lab nocons  tex keep(CSR_staff_social c.l1.UiIND_weighted $l1x1 )
		
	* ppmlhdfe with zeros
	ppmlhdfe CSR_staff_social c.l1.UiIND_weighted $l1x1 , a(i.nic_industry##i.year i.state_code) vce(cluster co_code)
	outreg2 using "${results_path}Table_5.tex", append addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes)  ctitle(CSR in USD, ppml, cross section)  addstat("Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) dec(3) lab nocons  tex keep(CSR_staff_social c.l1.UiIND_weighted $l1x1 )
	

*** Panel
	* CSR level 
	reghdfe l_CSR_staff_social c.l1.UiIND_weighted $l1x1 , a(co_code year) vce(cluster co_code) 
	outreg2 using "${results_path}Table_5.tex", append addtext(Firm dummy, Yes, Year dummy, Yes) addstat("Number of clusters", e(N_clust), "adjusted R2", e(r2_a), "adjusted within R2", e(r2_a_within))  ctitle((ln) CSR, OLS, panel)  dec(3) lab nocons  tex keep(l_CSR_staff_social c.l1.UiIND_weighted $l1x1 )

	* xtpoisson without zeros
	ppmlhdfe CSR_staff_social c.l1.UiIND_weighted $l1x1 if CSR_staff_social != 0, a(co_code year) vce(cluster co_code)
	outreg2 using "${results_path}Table_5.tex", append addtext(Firm dummy, Yes, Year dummy, Yes) addstat("Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) ctitle(CSR in USD, xtpoisson, panel) dec(3) lab nocons  tex keep(CSR_staff_social c.l1.UiIND_weighted $l1x1 )
		
	* xtpoisson with zeros
	ppmlhdfe CSR_staff_social c.l1.UiIND_weighted $l1x1, a(co_code year) vce(cluster co_code)
	outreg2 using "${results_path}Table_5.tex", append addtext(Firm dummy, Yes, Year dummy, Yes) addstat("Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) ctitle(CSR in USD, xtpoisson, panel) dec(3) lab nocons  tex keep(CSR_staff_social c.l1.UiIND_weighted $l1x1 )



*************************************************
**** 3.4.2 CSR as Share of Expenditure
*************************************************	
use "${data_path_prep}Total_merged_main_reg.dta", clear
	
	sort co_code year	
	xtset co_code year

	global l1x1	"c.l1.OECD_exp_exp_sh_weigh c.l1.l_comp_h_weigh c.l1.export_share c.l1.domestic_inputs_sh i.l1.SOE i.l1.foreign c.l1.l_sa_sales c.l1.l_age" 

				
*** Cross section
	reghdfe CSR_sh_expenses_wo_w c.l1.UiIND_weighted $l1x1 if sample_cr == 1 & CSR_sh_expenses_wo_w != 0, a(i.nic_industry##i.year i.state_code ) vce(cluster co_code) 
	outreg2 using "${results_path}Table_6.tex", replace addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes) addstat("Number of clusters", e(N_clust), "R2", e(r2), "adjusted R2", e(r2_a)) ctitle(CSR/expenses, OLS, cross section)  dec(3) lab nocons  tex keep(CSR_sh_expenses c.l1.UiIND_weighted $l1x1 )

	ppmlhdfe CSR_sh_expenses_wo_w c.l1.UiIND_weighted $l1x1 if sample_cr == 1 & CSR_sh_expenses_wo_w != 0, a(i.nic_industry##i.year i.state_code) vce(cluster co_code) d
	outreg2 using "${results_path}Table_6.tex", append addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes)  ctitle(CSR/expenses, ppml, cross section)  addstat("Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) dec(3) lab nocons  tex keep(CSR_sh_expenses c.l1.UiIND_weighted $l1x1 )
	
	* ppmlhdfe with zeros
	ppmlhdfe CSR_sh_expenses_wo_w c.l1.UiIND_weighted $l1x1 if sample_cr == 1, a(i.nic_industry##i.year i.state_code) vce(cluster co_code) d
	outreg2 using "${results_path}Table_6.tex", append addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes)  ctitle(CSR/expenses, ppml, cross section)  addstat("Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) dec(3) lab nocons  tex keep(CSR_sh_expenses c.l1.UiIND_weighted $l1x1 )
	
*** Panel
	* CSR, without zeros 
	reghdfe CSR_sh_expenses_wo_w c.l1.UiIND_weighted $l1x1 if sample_pa == 1 & CSR_sh_expenses_wo_w != 0, a(co_code i.year) vce(cluster co_code) 
	outreg2 using "${results_path}Table_6.tex", append addtext(Firm dummy, Yes, Year dummy, Yes) addstat("Number of clusters", e(N_clust), "adjusted R2", e(r2_a), "adjusted within R2", e(r2_a_within))  ctitle(CSR/expenses, OLS, panel)  dec(3) lab nocons  tex keep(CSR_sh_expenses c.l1.UiIND_weighted $l1x1 )

	ppmlhdfe CSR_sh_expenses_wo_w c.l1.UiIND_weighted $l1x1 if sample_pa == 1 & CSR_sh_expenses_wo_w != 0, a(co_code year) vce(cluster co_code) d
	outreg2 using "${results_path}Table_6.tex", append addtext(Firm dummy, Yes, Year dummy, Yes) addstat("Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) ctitle(CSR/expenses, xtpoisson, panel) dec(3) lab nocons  tex keep(CSR_sh_expenses c.l1.UiIND_weighted $l1x1 ) 	
			
	* xtpoisson with zeros
	ppmlhdfe CSR_sh_expenses_wo_w c.l1.UiIND_weighted $l1x1 if sample_pa == 1, a(co_code year) vce(cluster co_code) d
	outreg2 using "${results_path}Table_6.tex", append addtext(Firm dummy, Yes, Year dummy, Yes) addstat("Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) ctitle(CSR/expenses, xtpoisson, panel) dec(3) lab nocons  tex keep(CSR_sh_expenses c.l1.UiIND_weighted $l1x1 ) 	
	
	

*************************************************
**** 3.4.3 Labor Intensity
*************************************************	
use "${data_path_prep}Total_merged_main_reg.dta", clear

	sort co_code year	
	xtset co_code year


*** Exclude skill intensity and control for labor intensity, main sample
	global l1x1	"c.l1.OECD_exp_exp_sh_weigh c.l1.l_lab_int_weigh c.l1.export_share c.l1.domestic_inputs_sh i.l1.SOE i.l1.foreign c.l1.l_sa_sales  c.l1.l_age" 
	
	 cap drop _ppmlhdfe_d

*** Cross section
	* level	
	reghdfe l_CSR_staff_social c.l1.UiIND_weighted $l1x1, a(i.nic_industry##i.year i.state_code ) vce(cluster co_code) 
	outreg2 using "${results_path}Table_7.tex", replace addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes) addstat("Number of clusters", e(N_clust), "R2", e(r2), "adjusted R2", e(r2_a)) ctitle((ln) CSR, OLS, cross section)  dec(3) lab nocons  tex keep(l_CSR_staff_social c.l1.UiIND_weighted $l1x1 )
		
	
	* ppmlhdfe without zeros
	ppmlhdfe CSR_staff_social c.l1.UiIND_weighted $l1x1  if CSR_staff_social!=0 , a(i.nic_industry##i.year i.state_code) vce(cluster co_code) d
	outreg2 using "${results_path}Table_7.tex", append addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes)  ctitle(CSR in USD, ppml, cross section) addstat( "Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) dec(3) lab nocons  tex keep(CSR_staff_social c.l1.UiIND_weighted $l1x1 )
	

	* ppmlhdfe with zeros
	ppmlhdfe CSR_staff_social c.l1.UiIND_weighted $l1x1 , a(i.nic_industry##i.year i.state_code) vce(cluster co_code) d //verbose(2)
	outreg2 using "${results_path}Table_7.tex", append addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes)  ctitle(CSR in USD, ppml, cross section)  addstat("Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) dec(3) lab nocons  tex keep(CSR_staff_social c.l1.UiIND_weighted $l1x1 )


*** Panel
	* CSR level 
	reghdfe l_CSR_staff_social c.l1.UiIND_weighted $l1x1 , a(co_code i.year) vce(cluster co_code) 
	outreg2 using "${results_path}Table_7.tex", append addtext(Firm dummy, Yes, Year dummy, Yes) addstat("Number of clusters", e(N_clust), "adjusted R2", e(r2_a), "adjusted within R2", e(r2_a_within))  ctitle((ln) CSR, OLS, panel)  dec(3) lab nocons  tex keep(l_CSR_staff_social c.l1.UiIND_weighted $l1x1 )
	
	* xtpoisson without zeros
	ppmlhdfe CSR_staff_social c.l1.UiIND_weighted $l1x1 if CSR_staff_social != 0, a(co_code year) vce(cluster co_code) d 
	outreg2 using "${results_path}Table_7.tex", append addtext(Firm dummy, Yes, Year dummy, Yes) addstat("Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) ctitle(CSR in USD, xtpoisson, panel) dec(3) lab nocons  tex keep(CSR_staff_social c.l1.UiIND_weighted $l1x1 )
		
	* xtpoisson with zeros
	ppmlhdfe CSR_staff_social c.l1.UiIND_weighted $l1x1, a(co_code year) vce(cluster co_code) d
	outreg2 using "${results_path}Table_7.tex", append addtext(Firm dummy, Yes, Year dummy, Yes) addstat("Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) ctitle(CSR in USD, xtpoisson, panel) dec(3) lab nocons  tex keep(CSR_staff_social c.l1.UiIND_weighted $l1x1 ) 
	



*************************************************
**** 3.4.4 Smoothed CSR Spending
*************************************************
use "${data_path_prep}Total_merged_main_reg.dta", clear
	
keep co_code l_CSR_staff_social CSR_staff_social UiIND_weighted l_comp_h_weigh OECD_exp_exp_sh_weigh export_share domestic_inputs_sh ///
		SOE foreign l_sa_sales l_age nic_industry year state_code sample_ols_main sample_cr	
	
order co_code year foreign SOE sample_ols_main sample_cr state_code, a(nic_industry)	

	
	* create second-order moving averages 
	* (including the current observation, otherwise we have missings in current year)
	foreach var of varlist UiIND_weighted-l_CSR_staff_social {
	tssmooth ma ma1_`var' = `var', window(2 1)
	}
	

	// only use smoothed CSR spending, all other variables remain
	global l1x1	"c.l1.OECD_exp_exp_sh_weigh c.l1.l_comp_h_weigh c.l1.export_share c.l1.domestic_inputs_sh i.l1.SOE i.l1.foreign c.l1.l_sa_sales c.l1.l_age " 

	
*** Cross section
	* level	
	reghdfe ma1_l_CSR_staff_social c.l1.UiIND_weighted $l1x1, a(i.nic_industry##i.year i.state_code) vce(cluster co_code)
	outreg2 using "${results_path}Table_8.tex", replace addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes) addstat("Number of clusters", e(N_clust), "R2", e(r2), "adjusted R2", e(r2_a))   ctitle((ln) CSR, OLS, cross section)  dec(3) lab nocons  tex keep(ma1_l_CSR_staff_social c.l1.UiIND_weighted $l1x1 )
		
	
	* ppmlhdfe without zeros 
	ppmlhdfe ma1_CSR_staff_social c.l1.UiIND_weighted $l1x1  if ma1_CSR_staff_social!=0, a(i.nic_industry##i.year i.state_code) vce(cluster co_code)
	outreg2 using "${results_path}Table_8.tex", append addtext(Firm dummy, No, Industry*Period dummy, Yes, State dummy, Yes) ctitle(CSR in USD, ppml, cross section) addstat( "Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) dec(3) lab nocons  tex keep(ma1_CSR_staff_social c.l1.UiIND_weighted $l1x1 )

	
	* ppmlhdfe with zeros 
	ppmlhdfe ma1_CSR_staff_social c.l1.UiIND_weighted $l1x1, a(i.nic_industry##i.year i.state_code)  vce(cluster co_code)
	outreg2 using "${results_path}Table_8.tex", append addtext(Firm dummy, No, Industry*Period dummy, Yes, State dummy, Yes)  ctitle(CSR in USD, ppml, cross section)  addstat( "Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p))  dec(3) lab nocons  tex keep(ma1_CSR_staff_social c.l1.UiIND_weighted $l1x1 )
	

*** Panel
	* CSR level 
	reghdfe ma1_l_CSR_staff_social c.l1.UiIND_weighted $l1x1 , a(co_code i.year) vce(cluster co_code)
	outreg2 using "${results_path}Table_8.tex", append addtext(Firm dummy, Yes, Period dummy, Yes) addstat("Number of clusters", e(N_clust), "adjusted R2", e(r2_a), "adjusted within R2", e(r2_a_within))  ctitle((ln) CSR, OLS, panel)  dec(3) lab nocons  tex keep(ma1_l_CSR_staff_social c.l1.UiIND_weighted $l1x1 )

		
	* xtpoisson without zeros
	ppmlhdfe ma1_CSR_staff_social c.l1.UiIND_weighted  $l1x1 if ma1_CSR_staff_social != 0 , a(co_code i.year) vce(cluster co_code)
	outreg2 using "${results_path}Table_8.tex", append addtext(Firm dummy, Yes, Period dummy, Yes) addstat("Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p))   ctitle(CSR in USD, xtpoisson, panel) dec(3) lab nocons  tex keep(ma1_CSR_staff_social c.l1.UiIND_weighted $l1x1 )
	
	
	* xtpoisson with zeros
	ppmlhdfe ma1_CSR_staff_social c.l1.UiIND_weighted $l1x1, a(co_code i.year) vce(cluster co_code)
	outreg2 using "${results_path}Table_8.tex", append addtext(Firm dummy, Yes, Period dummy, Yes) addstat("Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p))  ctitle(CSR in USD, xtpoisson, panel) dec(3) lab nocons  tex keep(ma1_CSR_staff_social c.l1.UiIND_weighted $l1x1 )
	



*************************************************
**** 3.4.5 Inverse Hyperbolic Sine Transformation
*************************************************	
use "${data_path_prep}Total_merged_main_reg.dta", clear

	sort co_code year	
	xtset co_code year

global l1x1	"c.l1.OECD_exp_exp_sh_weigh c.l1.l_comp_h_weigh c.l1.export_share c.l1.domestic_inputs_sh i.l1.SOE i.l1.foreign c.l1.l_sa_sales c.l1.l_age " 
	

histogram asinh_CSR if sample_cr == 1, percent saving("${results_path}Figure_B2a", replace) xtitle("asinh (CSR in USD)")	
histogram asinh_mCSR if sample_cr == 1, percent saving("${results_path}Figure_B2b", replace) xtitle("asinh (CSR in million USD)")

	gr combine "${results_path}Figure_B2a" "${results_path}Figure_B2b"
	graph export "${results_path}Figure_B2.pdf", as(pdf) replace			
	graph save "${graphs_path}Figure_B2", replace	
	
*** Cross section
	* ppmlhdfe with zeros
	ppmlhdfe CSR_staff_social c.l1.UiIND_weighted $l1x1 , a(i.nic_industry##i.year i.state_code) vce(cluster co_code) d
	outreg2 using "${results_path}Table_9.tex", replace addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes)  ctitle(CSR in USD, ppml, cross section)  addstat("Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) dec(3) lab nocons  tex keep(c.l1.UiIND_weighted $l1x1 )
	

	* CSR in Dollar
	reghdfe asinh_CSR c.l1.UiIND_weighted $l1x1 if sample_cr ==1, a(i.nic_industry##i.year i.state_code ) vce(cluster co_code) 
	outreg2 using "${results_path}Table_9.tex", append addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes) addstat("Number of clusters", e(N_clust), "R2", e(r2), "adjusted R2", e(r2_a)) ctitle(asinh CSR, OLS, cross section)  dec(3) lab nocons  tex keep(c.l1.UiIND_weighted $l1x1 )
		
	* CSR in million	
	reghdfe asinh_mCSR c.l1.UiIND_weighted $l1x1 if sample_cr ==1, a(i.nic_industry##i.year i.state_code ) vce(cluster co_code) 
	outreg2 using "${results_path}Table_9.tex", append addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes) addstat("Number of clusters", e(N_clust), "R2", e(r2), "adjusted R2", e(r2_a)) ctitle(asinh mCSR, OLS, cross section)  dec(3) lab nocons  tex keep(c.l1.UiIND_weighted $l1x1 )

		
*** Panel
	* xtpoisson with zeros
	ppmlhdfe CSR_staff_social c.l1.UiIND_weighted $l1x1, a(co_code year) vce(cluster co_code) d
	outreg2 using "${results_path}Table_9.tex", append addtext(Firm dummy, Yes, Year dummy, Yes) addstat("Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) ctitle(CSR in USD, xtpoisson, panel) dec(3) lab nocons  tex keep(c.l1.UiIND_weighted $l1x1 ) 

	* CSR in Dollar 
	reghdfe asinh_CSR c.l1.UiIND_weighted $l1x1 if sample_pa ==1, a(co_code i.year) vce(cluster co_code) 
	outreg2 using "${results_path}Table_9.tex", append addtext(Firm dummy, Yes, Year dummy, Yes) addstat("Number of clusters", e(N_clust), "adjusted R2", e(r2_a), "adjusted within R2", e(r2_a_within))  ctitle(asinh CSR, OLS, panel)  dec(3) lab nocons  tex keep(c.l1.UiIND_weighted $l1x1 )

	* CSR level 
	reghdfe asinh_mCSR c.l1.UiIND_weighted $l1x1 if sample_pa ==1, a(co_code i.year) vce(cluster co_code) 
	outreg2 using "${results_path}Table_9.tex", append addtext(Firm dummy, Yes, Year dummy, Yes) addstat("Number of clusters", e(N_clust), "adjusted R2", e(r2_a), "adjusted within R2", e(r2_a_within))  ctitle(asinh mCSR, OLS, panel)  dec(3) lab nocons  tex keep(c.l1.UiIND_weighted $l1x1 )



graph close _all



*************************************************
**** 3.4.6 Shocks to Upstreamness
*************************************************	

use "${data_path_prep}Total_merged_main_reg.dta", clear

	sort co_code year	
	xtset co_code year

	global l1x1	"c.l1.OECD_exp_exp_sh_weigh c.l1.l_comp_h_weigh c.l1.export_share c.l1.domestic_inputs_sh i.l1.SOE i.l1.foreign c.l1.l_sa_sales c.l1.l_age" 
	


****** Table 10
**** IV: t-2 to t-1
	sum IV_shiftl1 if sample_cr == 1, det // Referred to in the paper
	
	* IV
	ivregress 2sls l_CSR_staff_social $l1x1 i.nic_industry##i.year i.state_code (c.l1.UiIND_weighted = c.IV_shift_shl1) if sample_cr == 1, vce(cluster co_code) 
	
	* Report first stage
	reghdfe l1.UiIND_weighted c.IV_shift_shl1 $l1x1 if e(sample) == 1, a(i.nic_industry##i.year i.state_code) vce(cluster co_code)	
		outreg2 using "${results_path}Table_10.tex", replace label addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes) addstat("Number of clusters", e(N_clust), "R2", e(r2), "adjusted R2", e(r2_a), "F-statistic", e(F)) ctitle(Cross, First) dec(3) tex keep(c.IV_shift_shl1 $l1x1 )	
	
	* Report IV
		ivregress 2sls l_CSR_staff_social $l1x1 i.nic_industry##i.year i.state_code (c.l1.UiIND_weighted = c.IV_shift_shl1) if e(sample) == 1, vce(cluster co_code) 
		outreg2 using "${results_path}Table_10.tex", append label addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes) addstat("Number of clusters", e(N_clust), "R2", e(r2), "adjusted R2", e(r2_a)) ctitle(Cross, IV) dec(3) tex keep(c.l1.UiIND_weighted $l1x1 )	
	
		
	* Panel
	* First stage	
	xtivreg l_CSR_staff_social $l1x1 i.year (c.l1.UiIND_weighted = c.IV_shift_shl1) if sample_pa == 1, fe vce(cluster co_code)
	
	xtreg l1.UiIND_weighted IV_shift_shl1 $l1x1 i.year if e(sample) == 1, fe vce(cluster co_code)
		outreg2 using "${results_path}Table_10.tex", append label addtext(Firm dummy, Yes, Year dummy, Yes) addstat("Number of clusters", e(N_clust), "R2 overall", e(r2_o), "R2 within", e(r2_w)) ctitle(Panel, First) dec(3) tex keep(IV_shift_shl1 $l1x1 )	
	
	xtivreg l_CSR_staff_social $l1x1 i.year (c.l1.UiIND_weighted = c.IV_shift_shl1) if e(sample) == 1, fe vce(cluster co_code)
		outreg2 using "${results_path}Table_10.tex", append label addtext(Firm dummy, Yes, Year dummy, Yes) addstat("Number of clusters", e(N_clust), "R2 overall", e(r2_o), "R2 within", e(r2_w), "F statistic", e(F_f)) ctitle(Panel, IV) dec(3) tex keep(c.l1.UiIND_weighted $l1x1 )	
	
	
	
	* Clustered at the 5 digit industry level
	ivregress 2sls l_CSR_staff_social $l1x1 i.nic_industry##i.year i.state_code (c.l1.UiIND_weighted = c.IV_shift_shl1) if sample_cr == 1, vce(cluster nic_prod_code) 

	reghdfe l1.UiIND_weighted c.IV_shift_shl1 $l1x1 if e(sample) == 1, a(i.nic_industry##i.year i.state_code ) vce(cluster nic_prod_code)	
		outreg2 using "${results_path}Table_10.tex", append label addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes) addstat("Number of clusters", e(N_clust), "R2", e(r2), "adjusted R2", e(r2_a), "F-statistic", e(F)) ctitle(Cross, First) dec(3) tex keep(c.IV_shift_shl1 $l1x1 )	
		
	ivregress 2sls l_CSR_staff_social $l1x1 i.nic_industry##i.year i.state_code (c.l1.UiIND_weighted = c.IV_shift_shl1) if e(sample) == 1, vce(cluster nic_prod_code) 
		outreg2 using "${results_path}Table_10.tex", append label addtext(Firm dummy, Yes, Year dummy, Yes) addstat("Number of clusters", e(N_clust), "R2", e(r2), "adjusted R2", e(r2_a)) ctitle(Cross, IV) dec(3) tex keep(c.l1.UiIND_weighted $l1x1 )	
		
	
	* First	
	xtivreg l_CSR_staff_social $l1x1 i.year (c.l1.UiIND_weighted = c.IV_shift_shl1) if sample_pa == 1, fe vce(cluster nic_prod_code)

	xtreg l1.UiIND_weighted IV_shift_shl1 $l1x1 i.year if e(sample) == 1, fe vce(cluster nic_prod_code)
		outreg2 using "${results_path}Table_10.tex", append label addtext(Firm dummy, Yes, Year dummy, Yes) addstat("Number of clusters", e(N_clust), "R2 overall", e(r2_o), "R2 within", e(r2_w)) ctitle(Panel, First) dec(3) tex keep(IV_shift_shl1 $l1x1 )	

	xtivreg l_CSR_staff_social $l1x1 i.year (c.l1.UiIND_weighted = c.IV_shift_shl1) if e(sample) == 1, fe vce(cluster nic_prod_code)
		outreg2 using "${results_path}Table_10.tex", append label addtext(Firm dummy, Yes, Year dummy, Yes) addstat("Number of clusters", e(N_clust), "R2 overall", e(r2_o), "R2 within", e(r2_w), "F statistic", e(F_f)) ctitle(Panel, IV) dec(3) tex keep(c.l1.UiIND_weighted $l1x1 )	
	
	
	
	
		
/*
	Table 11
	Use further lagged shares for cross section
*/		

**** IV: t-3 to t-1
	sum IV_shiftl2 if sample_cr == 1, det // Referred to in the paper

**** IV: t-3 to t-1
	ivregress 2sls l_CSR_staff_social $l1x1 i.nic_industry##i.year i.state_code (c.l1.UiIND_weighted = c.IV_shift_shl2) if sample_cr == 1, vce(cluster co_code) 
	
	* Report first stage
	reghdfe l1.UiIND_weighted c.IV_shift_shl2 $l1x1 if e(sample) == 1, a(i.nic_industry##i.year i.state_code ) vce(cluster co_code)	
		outreg2 using "${results_path}Table_B3.tex", replace label addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes) addstat("Number of clusters", e(N_clust), "R2", e(r2), "adjusted R2", e(r2_a), "F-statistic", e(F)) ctitle(Cross, First) dec(3) tex keep(c.IV_shift_shl2 $l1x1 )	
	
	ivregress 2sls l_CSR_staff_social $l1x1 i.nic_industry##i.year i.state_code (c.l1.UiIND_weighted = c.IV_shift_shl2) if e(sample) == 1, vce(cluster co_code) 
		outreg2 using "${results_path}Table_11.tex", replace label addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes) addstat("Number of clusters", e(N_clust), "R2", e(r2), "adjusted R2", e(r2_a)) ctitle(Cross, IV) dec(3) tex keep(c.l1.UiIND_weighted $l1x1 )	
	
	
	* Clustered at the 5 digit industry level
	ivregress 2sls l_CSR_staff_social $l1x1 i.nic_industry##i.year i.state_code (c.l1.UiIND_weighted = c.IV_shift_shl2) if sample_cr == 1, vce(cluster nic_prod_code) 
	
	reghdfe l1.UiIND_weighted c.IV_shift_shl2 $l1x1 if e(sample) == 1, a(i.nic_industry##i.year i.state_code ) vce(cluster nic_prod_code)	
		outreg2 using "${results_path}Table_B3.tex", append label addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes) addstat("Number of clusters", e(N_clust), "R2", e(r2), "adjusted R2", e(r2_a), "F-statistic", e(F)) ctitle(Cross, First) dec(3) tex keep(c.IV_shift_shl2 $l1x1 )	
	
	ivregress 2sls l_CSR_staff_social $l1x1 i.nic_industry##i.year i.state_code (c.l1.UiIND_weighted = c.IV_shift_shl2) if e(sample) == 1, vce(cluster nic_prod_code) 
		outreg2 using "${results_path}Table_11.tex", append label addtext(Firm dummy, Yes, Year dummy, Yes) addstat("Number of clusters", e(N_clust), "R2", e(r2), "adjusted R2", e(r2_a)) ctitle(Cross, IV) dec(3) tex keep(c.l1.UiIND_weighted $l1x1 )	


	
	
**** IV: t-4 to t-1	
	sum IV_shiftl3 if sample_cr == 1, det // Referred to in the paper

	* Report first stage
	ivregress 2sls l_CSR_staff_social $l1x1 i.nic_industry##i.year i.state_code (c.l1.UiIND_weighted = c.IV_shift_shl3) if sample_cr == 1, vce(cluster co_code) 
	
	reghdfe l1.UiIND_weighted c.IV_shift_shl3 $l1x1 if e(sample) == 1, a(i.nic_industry##i.year i.state_code ) vce(cluster co_code)	
		outreg2 using "${results_path}Table_B3.tex", append label addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes) addstat("Number of clusters", e(N_clust), "R2", e(r2), "adjusted R2", e(r2_a), "F-statistic", e(F)) ctitle(Cross, First) dec(3) tex keep(c.IV_shift_shl3 $l1x1 )	
	
	ivregress 2sls l_CSR_staff_social $l1x1 i.nic_industry##i.year i.state_code (c.l1.UiIND_weighted = c.IV_shift_shl3) if e(sample) == 1, vce(cluster co_code) 
		outreg2 using "${results_path}Table_11.tex", append label addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes) addstat("Number of clusters", e(N_clust), "R2", e(r2), "adjusted R2", e(r2_a)) ctitle(Cross, IV) dec(3) tex keep(c.l1.UiIND_weighted $l1x1 )	
	
	
	* Clustered at the 5 digit industry level
	ivregress 2sls l_CSR_staff_social $l1x1 i.nic_industry##i.year i.state_code (c.l1.UiIND_weighted = c.IV_shift_shl3) if sample_cr == 1, vce(cluster nic_prod_code) 

	reghdfe l1.UiIND_weighted c.IV_shift_shl3 $l1x1 if e(sample) == 1, a(i.nic_industry##i.year i.state_code ) vce(cluster nic_prod_code)	
		outreg2 using "${results_path}Table_B3.tex", append label addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes) addstat("Number of clusters", e(N_clust), "R2", e(r2), "adjusted R2", e(r2_a), "F-statistic", e(F)) ctitle(Cross, First) dec(3) tex keep(c.IV_shift_shl3 $l1x1 )	
	
	ivregress 2sls l_CSR_staff_social $l1x1 i.nic_industry##i.year i.state_code (c.l1.UiIND_weighted = c.IV_shift_shl3) if e(sample) == 1, vce(cluster nic_prod_code) 
		outreg2 using "${results_path}Table_11.tex", append label addtext(Firm dummy, Yes, Year dummy, Yes) addstat("Number of clusters", e(N_clust), "R2", e(r2), "adjusted R2", e(r2_a)) ctitle(Cross, IV) dec(3) tex keep(c.l1.UiIND_weighted $l1x1 )	
	
	
	
**** IV: t-5 to t-1
	sum IV_shiftl4 if sample_cr == 1, det // Referred to in the paper

	* Report first stage
	ivregress 2sls l_CSR_staff_social $l1x1 i.nic_industry##i.year i.state_code (c.l1.UiIND_weighted = c.IV_shift_shl4) if sample_cr == 1, vce(cluster co_code) 

	reghdfe l1.UiIND_weighted c.IV_shift_shl4 $l1x1 if e(sample) == 1, a(i.nic_industry##i.year i.state_code ) vce(cluster co_code)	
		outreg2 using "${results_path}Table_B3.tex", append label addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes) addstat("Number of clusters", e(N_clust), "R2", e(r2), "adjusted R2", e(r2_a), "F-statistic", e(F)) ctitle(Cross, First) dec(3) tex keep(c.IV_shift_shl4 $l1x1 )	
	
	ivregress 2sls l_CSR_staff_social $l1x1 i.nic_industry##i.year i.state_code (c.l1.UiIND_weighted = c.IV_shift_shl4) if e(sample) == 1, vce(cluster co_code) 
		outreg2 using "${results_path}Table_11.tex", append label addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes) addstat("Number of clusters", e(N_clust), "R2", e(r2), "adjusted R2", e(r2_a)) ctitle(Cross, IV) dec(3) tex keep(c.l1.UiIND_weighted $l1x1 )	
	
	
	* Clustered at the 5 digit industry level
	ivregress 2sls l_CSR_staff_social $l1x1 i.nic_industry##i.year i.state_code (c.l1.UiIND_weighted = c.IV_shift_shl4) if e(sample) == 1, vce(cluster nic_prod_code) 
	
	reghdfe l1.UiIND_weighted c.IV_shift_shl4 $l1x1 if e(sample) == 1, a(i.nic_industry##i.year i.state_code ) vce(cluster nic_prod_code)	
		outreg2 using "${results_path}Table_B3.tex", append label addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes) addstat("Number of clusters", e(N_clust), "R2", e(r2), "adjusted R2", e(r2_a), "F-statistic", e(F)) ctitle(Cross, First) dec(3) tex keep(c.IV_shift_shl4 $l1x1 )	
		
	ivregress 2sls l_CSR_staff_social $l1x1 i.nic_industry##i.year i.state_code (c.l1.UiIND_weighted = c.IV_shift_shl4) if e(sample) == 1, vce(cluster nic_prod_code) 
		outreg2 using "${results_path}Table_11.tex", append label addtext(Firm dummy, Yes, Year dummy, Yes) addstat("Number of clusters", e(N_clust), "R2", e(r2), "adjusted R2", e(r2_a)) ctitle(Cross, IV) dec(3) tex keep(c.l1.UiIND_weighted $l1x1 )	
	

**** IV: t-6 to t-1
	sum IV_shiftl5 if sample_cr == 1, det // Referred to in the paper

	* Report first stage
	ivregress 2sls l_CSR_staff_social $l1x1 i.nic_industry##i.year i.state_code (c.l1.UiIND_weighted = c.IV_shift_shl5) if sample_cr == 1, vce(cluster co_code) 
		
	reghdfe l1.UiIND_weighted c.IV_shift_shl5 $l1x1 if e(sample) == 1, a(i.nic_industry##i.year i.state_code ) vce(cluster co_code)	
		outreg2 using "${results_path}Table_B3.tex", append label addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes) addstat("Number of clusters", e(N_clust), "R2", e(r2), "adjusted R2", e(r2_a), "F-statistic", e(F)) ctitle(Cross, First) dec(3) tex keep(c.IV_shift_shl5 $l1x1 )	
	
	ivregress 2sls l_CSR_staff_social $l1x1 i.nic_industry##i.year i.state_code (c.l1.UiIND_weighted = c.IV_shift_shl5) if e(sample) == 1, vce(cluster co_code) 
		outreg2 using "${results_path}Table_11.tex", append label addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes) addstat("Number of clusters", e(N_clust), "R2", e(r2), "adjusted R2", e(r2_a)) ctitle(Cross, IV) dec(3) tex keep(c.l1.UiIND_weighted $l1x1 )		
	
	
	* Clustered at the 5 digit industry level
	ivregress 2sls l_CSR_staff_social $l1x1 i.nic_industry##i.year i.state_code (c.l1.UiIND_weighted = c.IV_shift_shl5) if sample_cr == 1, vce(cluster nic_prod_code) 

	reghdfe l1.UiIND_weighted c.IV_shift_shl5 $l1x1 if e(sample) == 1, a(i.nic_industry##i.year i.state_code ) vce(cluster nic_prod_code)	
		outreg2 using "${results_path}Table_B3.tex", append label addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes) addstat("Number of clusters", e(N_clust), "R2", e(r2), "adjusted R2", e(r2_a), "F-statistic", e(F)) ctitle(Cross, First) dec(3) tex keep(c.IV_shift_shl5 $l1x1 )	
	
	ivregress 2sls l_CSR_staff_social $l1x1 i.nic_industry##i.year i.state_code (c.l1.UiIND_weighted = c.IV_shift_shl5) if e(sample) == 1, vce(cluster nic_prod_code) 
		outreg2 using "${results_path}Table_11.tex", append label addtext(Firm dummy, Yes, Year dummy, Yes) addstat("Number of clusters", e(N_clust), "R2", e(r2), "adjusted R2", e(r2_a)) ctitle(Cross, IV) dec(3) tex keep(c.l1.UiIND_weighted $l1x1 )	
		
		
		
**** IV: t-7 to t-1
	sum IV_shiftl6 if sample_cr == 1, det // Referred to in the paper

	* Report first stage
	ivregress 2sls l_CSR_staff_social $l1x1 i.nic_industry##i.year i.state_code (c.l1.UiIND_weighted = c.IV_shift_shl6) if sample_cr == 1, vce(cluster co_code) 

	reghdfe l1.UiIND_weighted c.IV_shift_shl6 $l1x1 if e(sample) == 1, a(i.nic_industry##i.year i.state_code ) vce(cluster co_code)	
		outreg2 using "${results_path}Table_B3.tex", append label addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes) addstat("Number of clusters", e(N_clust), "R2", e(r2), "adjusted R2", e(r2_a), "F-statistic", e(F)) ctitle(Cross, First) dec(3) tex keep(c.IV_shift_shl6 $l1x1 )	
	
	ivregress 2sls l_CSR_staff_social $l1x1 i.nic_industry##i.year i.state_code (c.l1.UiIND_weighted = c.IV_shift_shl6) if e(sample) == 1, vce(cluster co_code) 
		outreg2 using "${results_path}Table_11.tex", append label addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes) addstat("Number of clusters", e(N_clust), "R2", e(r2), "adjusted R2", e(r2_a)) ctitle(Cross, IV) dec(3) tex keep(c.l1.UiIND_weighted $l1x1 )		
	
	
	* Clustered at the 5 digit industry level
	ivregress 2sls l_CSR_staff_social $l1x1 i.nic_industry##i.year i.state_code (c.l1.UiIND_weighted = c.IV_shift_shl6) if sample_cr == 1, vce(cluster nic_prod_code) 

	reghdfe l1.UiIND_weighted c.IV_shift_shl6 $l1x1 if e(sample) == 1, a(i.nic_industry##i.year i.state_code ) vce(cluster nic_prod_code)	
		outreg2 using "${results_path}Table_B3.tex", append label addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes) addstat("Number of clusters", e(N_clust), "R2", e(r2), "adjusted R2", e(r2_a), "F-statistic", e(F)) ctitle(Cross, First) dec(3) tex keep(c.IV_shift_shl6 $l1x1 )	
	
	ivregress 2sls l_CSR_staff_social $l1x1 i.nic_industry##i.year i.state_code (c.l1.UiIND_weighted = c.IV_shift_shl6) if e(sample) == 1, vce(cluster nic_prod_code) 
		outreg2 using "${results_path}Table_11.tex", append label addtext(Firm dummy, Yes, Year dummy, Yes) addstat("Number of clusters", e(N_clust), "R2", e(r2), "adjusted R2", e(r2_a)) ctitle(Cross, IV) dec(3) tex keep(c.l1.UiIND_weighted $l1x1 )	







********************************************************************************
*** Herkenhoff, Krautheim, Semrau and Steglich
* Corporate Social Responsibility along the Global Value Chain

* Do-file name: 09_CSR_Analysis_Appendix.do
* Authors: Finn Ole Semrau, Frauke Steglich

********************************************************************************

*************************************************
**** B.2: Regression results when missing CSR values are not replaced by zeros
*************************************************	
use "${data_path_prep}Total_merged_main_reg.dta", clear

	sort co_code year	
	xtset co_code year

	global l1x1	"c.l1.OECD_exp_exp_sh_weigh c.l1.l_comp_h_weigh c.l1.export_share c.l1.domestic_inputs_sh i.l1.SOE i.l1.foreign c.l1.l_sa_sales c.l1.l_age " 
	
*** Cross section
	* level	
	reghdfe l_CSR_staff_social_raw c.l1.UiIND_weighted $l1x1, a(i.nic_industry##i.year i.state_code ) vce(cluster co_code) 
	outreg2 using "${results_path}Table_B2.tex", replace addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes) addstat("Number of clusters", e(N_clust), "R2", e(r2), "adjusted R2", e(r2_a)) ctitle((ln) CSR, OLS, cross section)  dec(3) lab nocons  tex keep(l_CSR_staff_social_raw c.l1.UiIND_weighted $l1x1 )
	
	* ppmlhdfe without zeros
	ppmlhdfe CSR_staff_social_raw c.l1.UiIND_weighted $l1x1  if CSR_staff_social_raw!=0, a(i.nic_industry##i.year i.state_code) vce(cluster co_code) d
	outreg2 using "${results_path}Table_B2.tex", append addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes)  ctitle(CSR in USD, ppml, cross section) addstat( "Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) dec(3) lab nocons  tex keep(CSR_staff_social_raw c.l1.UiIND_weighted $l1x1 )

	* ppmlhdfe with zeros
	ppmlhdfe CSR_staff_social_raw c.l1.UiIND_weighted $l1x1 , a(i.nic_industry##i.year i.state_code) vce(cluster co_code) d
	outreg2 using "${results_path}Table_B2.tex", append addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes)  ctitle(CSR in USD, ppml, cross section)  addstat("Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) dec(3) lab nocons  tex keep(CSR_staff_social_raw c.l1.UiIND_weighted $l1x1 )


*** Panel
	* CSR level 
	reghdfe l_CSR_staff_social_raw c.l1.UiIND_weighted $l1x1 , a(co_code i.year) vce(cluster co_code) 
	outreg2 using "${results_path}Table_B2.tex", append addtext(Firm dummy, Yes, Year dummy, Yes) addstat("Number of clusters", e(N_clust), "adjusted R2", e(r2_a), "adjusted within R2", e(r2_a_within))  ctitle((ln) CSR, OLS, panel)  dec(3) lab nocons  tex keep(l_CSR_staff_social_raw c.l1.UiIND_weighted $l1x1 )
	
	* xtpoisson without zeros
	ppmlhdfe CSR_staff_social_raw c.l1.UiIND_weighted $l1x1 if CSR_staff_social_raw != 0, a(co_code year) vce(cluster co_code) d
	outreg2 using "${results_path}Table_B2.tex", append addtext(Firm dummy, Yes, Year dummy, Yes) addstat("Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) ctitle(CSR in USD, xtpoisson, panel) dec(3) lab nocons  tex keep(CSR_staff_social_raw c.l1.UiIND_weighted $l1x1 )
	
	* xtpoisson with zeros
	ppmlhdfe CSR_staff_social_raw c.l1.UiIND_weighted $l1x1, a(co_code year) vce(cluster co_code) d
	outreg2 using "${results_path}Table_B2.tex", append addtext(Firm dummy, Yes, Year dummy, Yes) addstat("Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) ctitle(CSR in USD, xtpoisson, panel) dec(3) lab nocons  tex keep(CSR_staff_social_raw c.l1.UiIND_weighted $l1x1 )
	

	
*************************************************
**** B.4: Panel regression results: Excluding switchers and balanced panel
*************************************************	
use "${data_path_prep}Total_merged_main_reg.dta", clear

	sort co_code year	
	xtset co_code year

	
	global l1x1	"c.l1.OECD_exp_exp_sh_weigh c.l1.l_comp_h_weigh c.l1.export_share c.l1.domestic_inputs_sh i.l1.SOE i.l1.foreign c.l1.l_sa_sales c.l1.l_age" 

***********************************
*** Combination: Focus on panel 
*** because exit and entry only matter for panel variation

*** Panel
	* CSR level 
	reghdfe l_CSR_staff_social c.l1.UiIND_weighted $l1x1 if switcher==0, a(co_code i.year) vce(cluster co_code) 
	outreg2 using "${results_path}Table_B4.tex", replace addtext(Firm dummy, Yes, Year dummy, Yes) addstat("Number of clusters", e(N_clust), "adjusted R2", e(r2_a), "adjusted within R2", e(r2_a_within))  ctitle((ln) CSR, OLS, panel, w/o switchers)  dec(3) lab nocons  tex keep(l_CSR_staff_social c.l1.UiIND_weighted $l1x1 )

	
	* xtpoisson without zeros
	ppmlhdfe CSR_staff_social c.l1.UiIND_weighted $l1x1 if switcher==0 & CSR_staff_social != 0, a(co_code year) vce(cluster co_code) d
	outreg2 using "${results_path}Table_B4.tex", append addtext(Firm dummy, Yes, Year dummy, Yes) addstat("Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) ctitle(CSR in USD, xtpoisson, panel, w/o switchers) dec(3) lab nocons  tex keep(CSR_staff_social c.l1.UiIND_weighted $l1x1 )
	
	
	* xtpoisson with zeros
	ppmlhdfe CSR_staff_social c.l1.UiIND_weighted $l1x1 if switcher==0, a(co_code year) vce(cluster co_code) d
	outreg2 using "${results_path}Table_B4.tex", append addtext(Firm dummy, Yes, Year dummy, Yes) addstat("Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) ctitle(CSR in USD, xtpoisson, panel, w/o switchers) dec(3) lab nocons  tex keep(CSR_staff_social c.l1.UiIND_weighted $l1x1 ) 	
	
	
*** Panel
	* CSR level 
	reghdfe l_CSR_staff_social c.l1.UiIND_weighted $l1x1 if balanced == 14 & switcher==0, a(co_code i.year) vce(cluster co_code) 
	outreg2 using "${results_path}Table_B4.tex", append addtext(Firm dummy, Yes, Year dummy, Yes) addstat("Number of clusters", e(N_clust), "adjusted R2", e(r2_a), "adjusted within R2", e(r2_a_within))  ctitle((ln) CSR, OLS, panel, w/o switchers, \& balanced (14 years))  dec(3) lab nocons  tex keep(l_CSR_staff_social c.l1.UiIND_weighted $l1x1 )

	
	* xtpoisson without zeros
	ppmlhdfe CSR_staff_social c.l1.UiIND_weighted $l1x1 if balanced == 14 & switcher==0 & CSR_staff_social != 0, a(co_code year) vce(cluster co_code) d
	outreg2 using "${results_path}Table_B4.tex", append addtext(Firm dummy, Yes, Year dummy, Yes) addstat("Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) ctitle(CSR in USD, xtpoisson, panel, w/o switchers, \& balanced (14 years)) dec(3) lab nocons  tex keep(CSR_staff_social c.l1.UiIND_weighted $l1x1 )
	
	
	* xtpoisson with zeros
	ppmlhdfe CSR_staff_social c.l1.UiIND_weighted $l1x1 if balanced == 14 & switcher==0, a(co_code year) vce(cluster co_code) d
	outreg2 using "${results_path}Table_B4.tex", append addtext(Firm dummy, Yes, Year dummy, Yes) addstat("Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) ctitle(CSR in USD, xtpoisson, panel, w/o switchers, \& balanced (14 years)) dec(3) lab nocons  tex keep(CSR_staff_social c.l1.UiIND_weighted $l1x1 ) 


	
	
*************************************************
**** B.5: Regression results: Alternative set of fixed effects
*************************************************	
use "${data_path_prep}Total_merged_main_reg.dta", clear

	sort co_code year	
	xtset co_code year

	global l1x1	"c.l1.OECD_exp_exp_sh_weigh c.l1.l_comp_h_weigh c.l1.export_share c.l1.domestic_inputs_sh i.l1.SOE i.l1.foreign c.l1.l_sa_sales c.l1.l_age" 
	
*** Cross section
	* level	
	reghdfe l_CSR_staff_social c.l1.UiIND_weighted $l1x1, a(i.nic_industry##i.year##i.state_code ) vce(cluster co_code) 
	outreg2 using "${results_path}Table_B5.tex", replace addtext(Firm dummy, No, Industry*Year*State dummy, Yes) addstat("Number of clusters", e(N_clust), "R2", e(r2), "adjusted R2", e(r2_a)) ctitle((ln) CSR, OLS, cross section)  dec(3) lab nocons  tex keep(l_CSR_staff_social c.l1.UiIND_weighted $l1x1 )
	
	* ppmlhdfe without zeros
	ppmlhdfe CSR_staff_social c.l1.UiIND_weighted $l1x1  if CSR_staff_social!=0, a(i.nic_industry##i.year##i.state_code) vce(cluster co_code) d
	outreg2 using "${results_path}Table_B5.tex", append addtext(Firm dummy, No, Industry*Year*State dummy, Yes)  ctitle(CSR in USD, ppml, cross section) addstat( "Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) dec(3) lab nocons  tex keep(CSR_staff_social c.l1.UiIND_weighted $l1x1 )
		
	* ppmlhdfe with zeros
	ppmlhdfe CSR_staff_social c.l1.UiIND_weighted $l1x1 , a(i.nic_industry##i.year##i.state_code) vce(cluster co_code) d
	outreg2 using "${results_path}Table_B5.tex", append addtext(Firm dummy, No, Industry*Year*State dummy, Yes)  ctitle(CSR in USD, ppml, cross section)  addstat("Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) dec(3) lab nocons  tex keep(CSR_staff_social c.l1.UiIND_weighted $l1x1 )

	

*************************************************
**** Not reported additional robustness checks (but referred to)
*************************************************	
	

*************************************************
**** Check anticipation effects due to the CSR reform
**** -> exclude the years after 2010
*************************************************	

	use "${data_path_prep}Total_merged_main_reg.dta", clear
	
	sort co_code year	
	xtset co_code year

	global l1x1	"c.l1.OECD_exp_exp_sh_weigh c.l1.l_comp_h_weigh c.l1.export_share c.l1.domestic_inputs_sh i.l1.SOE i.l1.foreign c.l1.l_sa_sales c.l1.l_age" 

	
*** Cross section
	* level	
	reghdfe l_CSR_staff_social c.l1.UiIND_weighted $l1x1 if year<=2011, a(i.nic_industry##i.year i.state_code ) vce(cluster co_code) 
		outreg2 using "${results_path}Results_rob_CSRreform.tex", replace addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes) addstat("Number of clusters", e(N_clust), "R2", e(r2), "adjusted R2", e(r2_a)) ctitle((ln) CSR, OLS, cross section)  dec(3) lab nocons  tex keep(l_CSR_staff_social c.l1.UiIND_weighted $l1x1 )

	
	* ppmlhdfe without zeros
	ppmlhdfe CSR_staff_social c.l1.UiIND_weighted $l1x1  if CSR_staff_social!=0 & year<=2011, a(i.nic_industry##i.year i.state_code) vce(cluster co_code)
		outreg2 using "${results_path}Results_rob_CSRreform.tex", append addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes)  ctitle(CSR in USD, ppml, cross section) addstat( "Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) dec(3) lab nocons  tex keep(CSR_staff_social c.l1.UiIND_weighted $l1x1 )

	* ppmlhdfe with zeros
	ppmlhdfe CSR_staff_social c.l1.UiIND_weighted $l1x1 if year<=2011, a(i.nic_industry##i.year i.state_code) vce(cluster co_code)
		outreg2 using "${results_path}Results_rob_CSRreform.tex", append addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes)  ctitle(CSR in USD, ppml, cross section)  addstat("Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) dec(3) lab nocons  tex keep(CSR_staff_social c.l1.UiIND_weighted $l1x1 )

*** Panel
	* CSR level 
	reghdfe l_CSR_staff_social c.l1.UiIND_weighted $l1x1 if year<=2011, a(co_code year) vce(cluster co_code) 
		outreg2 using "${results_path}Results_rob_CSRreform.tex", append addtext(Firm dummy, Yes, Year dummy, Yes) addstat("Number of clusters", e(N_clust), "adjusted R2", e(r2_a), "adjusted within R2", e(r2_a_within))  ctitle((ln) CSR, OLS, panel)  dec(3) lab nocons  tex keep(l_CSR_staff_social c.l1.UiIND_weighted $l1x1 )

	* xtpoisson without zeros
		ppmlhdfe CSR_staff_social c.l1.UiIND_weighted $l1x1 if CSR_staff_social != 0 & year<=2011, a(co_code year) vce(cluster co_code)
	outreg2 using "${results_path}Results_rob_CSRreform.tex", append addtext(Firm dummy, Yes, Year dummy, Yes) addstat("Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) ctitle(CSR in USD, xtpoisson, panel) dec(3) lab nocons  tex keep(CSR_staff_social c.l1.UiIND_weighted $l1x1 )
	
		* xtpoisson with zeros
		ppmlhdfe CSR_staff_social c.l1.UiIND_weighted $l1x1 if year<=2011, a(co_code year) vce(cluster co_code)
	outreg2 using "${results_path}Results_rob_CSRreform.tex", append addtext(Firm dummy, Yes, Year dummy, Yes) addstat("Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) ctitle(CSR in USD, xtpoisson, panel) dec(3) lab nocons  tex keep(CSR_staff_social c.l1.UiIND_weighted $l1x1 )


*************************************************
**** Environmental spending included in CSR variable
* Not necessary voluntary, hence not appropriate to use
*************************************************	

use "${data_path_prep}Total_merged_main_reg.dta", clear

	sort co_code year	
	xtset co_code year
	
	global l1x1	"c.l1.OECD_exp_exp_sh_weigh c.l1.l_comp_h_weigh c.l1.export_share c.l1.domestic_inputs_sh i.l1.SOE i.l1.foreign c.l1.l_sa_sales c.l1.l_age" 
	
*** Cross section incl. environmental spending
	* level	
	reghdfe l_CSR_total_dollar c.l1.UiIND_weighted $l1x1, a(i.nic_industry##i.year i.state_code ) vce(cluster co_code) 
		outreg2 using "${results_path}Results_robust_env.tex", replace addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes)  ctitle((ln) CSR, OLS, cross section)  dec(3) lab nocons  tex keep(l_CSR_total_dollar c.l1.UiIND_weighted $l1x1 )
	
	* ppmlhdfe without zeros
	ppmlhdfe CSR_total_dollar c.l1.UiIND_weighted $l1x1  if CSR_staff_social!=0, a(i.nic_industry##i.year i.state_code) vce(cluster co_code) d
		outreg2 using "${results_path}Results_robust_env.tex", append addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes)  ctitle(CSR in USD, ppml, cross section) addstat("Pseudo R$^2$", e(r2_p)) dec(3) lab nocons  tex keep(CSR_total_dollar c.l1.UiIND_weighted $l1x1 )
	
	* ppmlhdfe with zeros
	ppmlhdfe CSR_total_dollar c.l1.UiIND_weighted $l1x1 , a(i.nic_industry##i.year i.state_code) vce(cluster co_code) d
		outreg2 using "${results_path}Results_robust_env.tex", append addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes)  ctitle(CSR in USD, ppml, cross section)  addstat("Pseudo R$^2$", e(r2_p)) dec(3) lab nocons  tex keep(CSR_total_dollar c.l1.UiIND_weighted $l1x1 )


*** Panel incl. environmental spending
	* CSR level 
	reghdfe l_CSR_total_dollar c.l1.UiIND_weighted $l1x1 , a(co_code i.year) vce(cluster co_code) 
		outreg2 using "${results_path}Results_robust_env.tex", append addtext(Firm dummy, Yes, Year dummy, Yes, Industry dummy, No) ctitle((ln) CSR, OLS, panel)  dec(3) lab nocons  tex keep(l_CSR_total_dollar c.l1.UiIND_weighted $l1x1 )
	
	* xtpoisson without zeros
	ppmlhdfe CSR_total_dollar c.l1.UiIND_weighted $l1x1 if CSR_staff_social != 0, a(co_code year) vce(cluster co_code) d
		outreg2 using "${results_path}Results_robust_env.tex", append addtext(Firm dummy, Yes, Year dummy, Yes, Industry dummy, No) ctitle(CSR in USD, xtpoisson, panel) dec(3) lab nocons  tex keep(CSR_total_dollar c.l1.UiIND_weighted $l1x1 )
		
	* xtpoisson with zeros
	ppmlhdfe CSR_total_dollar c.l1.UiIND_weighted $l1x1, a(co_code year) vce(cluster co_code) d
		outreg2 using "${results_path}Results_robust_env.tex", append addtext(Firm dummy, Yes, Year dummy, Yes, Industry dummy, No) ctitle(CSR in USD, xtpoisson, panel) dec(3) lab nocons  tex keep(CSR_total_dollar c.l1.UiIND_weighted $l1x1 )
	



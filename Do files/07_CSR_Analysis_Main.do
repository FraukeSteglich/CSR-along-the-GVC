********************************************************************************
*** Herkenhoff, Krautheim, Semrau and Steglich
* Corporate Social Responsibility along the Global Value Chain

* Do-file name: 07_CSR_Analysis_Main.do
* Authors: Finn Ole Semrau, Frauke Steglich
* Last update: 11.12.2023	

********************************************************************************

use "${data_path_prep}Total_merged_prepared.dta", clear

	sort co_code year	
	xtset co_code year

	global l1x1	"c.l1.OECD_exp_exp_sh_weigh c.l1.l_comp_h_weigh c.l1.export_share c.l1.domestic_inputs_sh i.l1.SOE i.l1.foreign c.l1.l_sa_sales c.l1.l_age " 


******** Section 3.3.3: Table 3 and Figure 2
*** Cross section
	* level	
	reghdfe l_CSR_staff_social c.l1.UiIND_weighted $l1x1, a(i.nic_industry##i.year i.state_code ) vce(cluster co_code) 
		gen sample_ols_main = e(sample) 
	outreg2 using "${results_path}Table_3.tex", replace addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes) addstat("Number of clusters", e(N_clust), "R2", e(r2), "adjusted R2", e(r2_a)) ctitle((ln) CSR, OLS, cross section)  dec(3) lab nocons  tex keep(l_CSR_staff_social c.l1.UiIND_weighted $l1x1 )
		margins,  at((p5) c.l1.UiIND_weighted)  at((p10) c.l1.UiIND_weighted) at((p15) c.l1.UiIND_weighted)  at((p20) c.l1.UiIND_weighted) at((p25) c.l1.UiIND_weighted)  at((p30) c.l1.UiIND_weighted) at((p35) c.l1.UiIND_weighted)  at((p40) c.l1.UiIND_weighted) at((p45) c.l1.UiIND_weighted)  at((p50) c.l1.UiIND_weighted) at((p55) c.l1.UiIND_weighted)  at((p60) c.l1.UiIND_weighted) at((p65) c.l1.UiIND_weighted)  at((p70) c.l1.UiIND_weighted) at((p75) c.l1.UiIND_weighted)  at((p80) c.l1.UiIND_weighted) at((p85) c.l1.UiIND_weighted)  at((p90) c.l1.UiIND_weighted) at((p95) c.l1.UiIND_weighted) 	
		marginsplot, xlabel(1 "p5" 2 "p10" 3 "p15" 4 "p20" 5 "p25" 6 "p30" 7 "p35" 8 "p40" 9 "p45" 10 "p50" 11 "p55" 12 "p60" 13 "p65" 14 "p70" 15 "p75" 16 "p80" 17 "p85" 18 "p90" 19 "p95") ///
		xtitle("Upstreamness (percentiles)")    /// 
		ytitle("Linear Prediction of CSR")		
		graph export "${graphs_path}Figure_2a.pdf", as(pdf) replace 
	
	
	* ppmlhdfe without zeros
	ppmlhdfe CSR_staff_social c.l1.UiIND_weighted $l1x1  if CSR_staff_social!=0, a(i.nic_industry##i.year i.state_code) vce(cluster co_code) d
	outreg2 using "${results_path}Table_3.tex", append addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes)  ctitle(CSR in USD, ppml, cross section) addstat( "Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) dec(3) lab nocons  tex keep(CSR_staff_social c.l1.UiIND_weighted $l1x1 )
		margins,  at((p5) c.l1.UiIND_weighted)  at((p10) c.l1.UiIND_weighted) at((p15) c.l1.UiIND_weighted)  at((p20) c.l1.UiIND_weighted) at((p25) c.l1.UiIND_weighted)  at((p30) c.l1.UiIND_weighted) at((p35) c.l1.UiIND_weighted)  at((p40) c.l1.UiIND_weighted) at((p45) c.l1.UiIND_weighted)  at((p50) c.l1.UiIND_weighted) at((p55) c.l1.UiIND_weighted)  at((p60) c.l1.UiIND_weighted) at((p65) c.l1.UiIND_weighted)  at((p70) c.l1.UiIND_weighted) at((p75) c.l1.UiIND_weighted)  at((p80) c.l1.UiIND_weighted) at((p85) c.l1.UiIND_weighted)  at((p90) c.l1.UiIND_weighted) at((p95) c.l1.UiIND_weighted) 	
		marginsplot, xlabel(1 "p5" 2 "p10" 3 "p15" 4 "p20" 5 "p25" 6 "p30" 7 "p35" 8 "p40" 9 "p45" 10 "p50" 11 "p55" 12 "p60" 13 "p65" 14 "p70" 15 "p75" 16 "p80" 17 "p85" 18 "p90" 19 "p95") ///
					xtitle("Upstreamness (percentiles)")    /// 
					ytitle("Linear Prediction of CSR")		
		graph export "${graphs_path}Figure_2b.pdf", as(pdf) replace 
	
	drop _ppmlhdfe_d


	* ppmlhdfe with zeros
	ppmlhdfe CSR_staff_social c.l1.UiIND_weighted $l1x1 , a(i.nic_industry##i.year i.state_code) vce(cluster co_code) d
		gen sample_cr = e(sample) // Focus descriptive statistics on sample of main specification
	outreg2 using "${results_path}Table_3.tex", append addtext(Firm dummy, No, Industry*Year dummy, Yes, State dummy, Yes)  ctitle(CSR in USD, ppml, cross section)  addstat("Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) dec(3) lab nocons  tex keep(CSR_staff_social c.l1.UiIND_weighted $l1x1 )
		margins,  at((p5) c.l1.UiIND_weighted)  at((p10) c.l1.UiIND_weighted) at((p15) c.l1.UiIND_weighted)  at((p20) c.l1.UiIND_weighted) at((p25) c.l1.UiIND_weighted)  at((p30) c.l1.UiIND_weighted) at((p35) c.l1.UiIND_weighted)  at((p40) c.l1.UiIND_weighted) at((p45) c.l1.UiIND_weighted)  at((p50) c.l1.UiIND_weighted) at((p55) c.l1.UiIND_weighted)  at((p60) c.l1.UiIND_weighted) at((p65) c.l1.UiIND_weighted)  at((p70) c.l1.UiIND_weighted) at((p75) c.l1.UiIND_weighted)  at((p80) c.l1.UiIND_weighted) at((p85) c.l1.UiIND_weighted)  at((p90) c.l1.UiIND_weighted) at((p95) c.l1.UiIND_weighted) 	
		marginsplot, xlabel(1 "p5" 2 "p10" 3 "p15" 4 "p20" 5 "p25" 6 "p30" 7 "p35" 8 "p40" 9 "p45" 10 "p50" 11 "p55" 12 "p60" 13 "p65" 14 "p70" 15 "p75" 16 "p80" 17 "p85" 18 "p90" 19 "p95") ///
					xtitle("Upstreamness (percentiles)")    /// 
					ytitle("Linear Prediction of CSR")	ylabel(50000(50000)200000)	
		graph export "${graphs_path}Figure_2c.pdf", as(pdf) replace 

		drop _ppmlhdfe_d

*** Panel
	* CSR level 
	reghdfe l_CSR_staff_social c.l1.UiIND_weighted $l1x1 , a(co_code i.year) vce(cluster co_code) 
		gen sample_pa_ols = e(sample)
				
	outreg2 using "${results_path}Table_3.tex", append addtext(Firm dummy, Yes, Year dummy, Yes) addstat("Number of clusters", e(N_clust), "adjusted R2", e(r2_a), "adjusted within R2", e(r2_a_within))  ctitle((ln) CSR, OLS, panel)  dec(3) lab nocons  tex keep(l_CSR_staff_social c.l1.UiIND_weighted $l1x1 )

	* Create graphical output (year needs to be specified, hence use xtreg)
	reghdfe l_CSR_staff_social c.l1.UiIND_weighted $l1x1 i.year, a(co_code) vce(cluster co_code)
	margins, at(year = 2001 (p5) c.l1.UiIND_weighted)  at(year = 2001 (p10) c.l1.UiIND_weighted) at(year = 2001 (p15) c.l1.UiIND_weighted)  at(year = 2001 (p20) c.l1.UiIND_weighted) at(year = 2001 (p25) c.l1.UiIND_weighted)  at(year = 2001 (p30) c.l1.UiIND_weighted) at(year = 2001 (p35) c.l1.UiIND_weighted)  at(year = 2001 (p40) c.l1.UiIND_weighted) at(year = 2001 (p45) c.l1.UiIND_weighted)  at(year = 2001 (p50) c.l1.UiIND_weighted) at(year = 2001 (p55) c.l1.UiIND_weighted)  at(year = 2001 (p60) c.l1.UiIND_weighted) at(year = 2001 (p65) c.l1.UiIND_weighted)  at(year = 2001 (p70) c.l1.UiIND_weighted) at(year = 2001 (p75) c.l1.UiIND_weighted)  at(year = 2001 (p80) c.l1.UiIND_weighted) at(year = 2001 (p85) c.l1.UiIND_weighted)  at(year = 2001 (p90) c.l1.UiIND_weighted) at(year = 2001 (p95) c.l1.UiIND_weighted) 	
		marginsplot, xlabel(1 "p5" 2 "p10" 3 "p15" 4 "p20" 5 "p25" 6 "p30" 7 "p35" 8 "p40" 9 "p45" 10 "p50" 11 "p55" 12 "p60" 13 "p65" 14 "p70" 15 "p75" 16 "p80" 17 "p85" 18 "p90" 19 "p95") ///
					xtitle("Upstreamness (percentiles)")    /// 
					ytitle("Linear Prediction of CSR")        
		graph export "${graphs_path}Figure_2d.pdf", as(pdf) replace 
	
	* xtpoisson without zeros
	ppmlhdfe CSR_staff_social c.l1.UiIND_weighted $l1x1 if CSR_staff_social != 0, a(co_code year) vce(cluster co_code) d
	outreg2 using "${results_path}Table_3.tex", append addtext(Firm dummy, Yes, Year dummy, Yes) addstat("Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) ctitle(CSR in USD, xtpoisson, panel) dec(3) lab nocons  tex keep(CSR_staff_social c.l1.UiIND_weighted $l1x1 )
	/* 
	Margins do not make sense: https://hbs-rcs.github.io/post/2017-02-16-margins_nonlinear/
	*/
	
	drop _ppmlhdfe_d
	
	* xtpoisson with zeros
	ppmlhdfe CSR_staff_social c.l1.UiIND_weighted $l1x1, a(co_code year) vce(cluster co_code) d
		gen sample_pa = e(sample)

	outreg2 using "${results_path}Table_3.tex", append addtext(Firm dummy, Yes, Year dummy, Yes) addstat("Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) ctitle(CSR in USD, xtpoisson, panel) dec(3) lab nocons  tex keep(CSR_staff_social c.l1.UiIND_weighted $l1x1 ) 
	
	save "${data_path_prep}Total_merged_main_reg.dta", replace	


	
***** Figure 1
* Binscatter
use "${data_path_prep}Total_merged_main_reg.dta", clear
	sort co_code year	
	xtset co_code year
	
	binscatter l_CSR_staff_social UiIND_weighted if sample_ols_main == 1, nquantiles(100)  ///
					xtitle("Upstreamness (mean per bin)")    /// 
					ytitle("(ln) CSR spending in USD (mean per bin)")  ///
					title("Correlation between CSR spending & upstreamness") ///
					xlabel(1(0.5)4) ylabel(9(0.5)11) mcolors(green) lcolors(darkblue) ///
					reportreg

	graph export "${graphs_path}Figure_1.pdf", as(pdf) replace
	graph save "${graphs_path}Figure_1", replace
	

	
*************************************************
**** 3.3.4 Controlling for contract enforcement
*************************************************		
use "${data_path_prep}Total_merged_main_reg.dta", clear
	lab var cost_enforce_median "lower judicial efficiency (median)"
	lab var cost_enforce_top9 "lower judicial efficiency (ranking)"	
	
	sort co_code year	
	xtset co_code year

	global l1x1	"c.l1.OECD_exp_exp_sh_weigh c.l1.l_comp_h_weigh c.l1.export_share c.l1.domestic_inputs_sh i.l1.SOE i.l1.foreign c.l1.l_sa_sales c.l1.l_age" 
	

*********************************************
*** Interactions with categories for only one year
*********************************************
	cap drop sample_ols_main_enforce09
	cap drop sample_ppml_main_enforce09
	
	reghdfe l_CSR_staff_social c.l1.UiIND_weighted c.l1.UiIND_weighted#i.cost_enforce_median $l1x1 if year == 2009, a(i.nic_industry i.state_code) vce(cluster co_code) 
	gen sample_ols_main_enforce09 = e(sample) 
	
	ppmlhdfe CSR_staff_social c.l1.UiIND_weighted c.l1.UiIND_weighted#i.cost_enforce_median $l1x1 if year == 2009, a(i.nic_industry i.state_code) vce(cluster co_code) d
	gen sample_ppml_main_enforce09 = e(sample) 
	
*** Cross section with regional contract enforcement measure interacted with upstreamness
	* level	
	reghdfe l_CSR_staff_social c.l1.UiIND_weighted $l1x1 if sample_ols_main_enforce09== 1 & year == 2009, a(i.nic_industry i.state_code ) vce(cluster co_code) 
	outreg2 using "${results_path}Table_4.tex", replace addtext(Firm dummy, No, Industry dummy, Yes, State dummy, Yes) addstat("Number of clusters", e(N_clust), "R2", e(r2), "adjusted R2", e(r2_a)) ctitle((ln) CSR, OLS, cross section)  dec(3) lab nocons  tex keep(l_CSR_staff_social c.l1.UiIND_weighted $l1x1 )
	
	reghdfe l_CSR_staff_social c.l1.UiIND_weighted c.l1.UiIND_weighted#i.cost_enforce_median $l1x1 if sample_ols_main_enforce09== 1 & year == 2009, a(i.nic_industry i.state_code) vce(cluster co_code) 
		outreg2 using "${results_path}Table_4.tex", append addtext(Firm dummy, No, Industry dummy, Yes, State dummy, Yes) addstat("Number of clusters", e(N_clust), "R2", e(r2), "adjusted R2", e(r2_a)) ctitle((ln) CSR, OLS, cross section)  dec(3) lab nocons  tex keep(l_CSR_staff_social c.l1.UiIND_weighted c.l1.UiIND_weighted#i.cost_enforce_median $l1x1)

		reghdfe l_CSR_staff_social c.l1.UiIND_weighted c.l1.UiIND_weighted#i.cost_enforce_top9 $l1x1 if sample_ols_main_enforce09==1 & year == 2009, a(i.nic_industry i.state_code) vce(cluster co_code) 
		outreg2 using "${results_path}Table_4.tex", append addtext(Firm dummy, No, Industry dummy, Yes, State dummy, Yes) addstat("Number of clusters", e(N_clust), "R2", e(r2), "adjusted R2", e(r2_a)) ctitle((ln) CSR, OLS, cross section)  dec(3) lab nocons  tex keep(l_CSR_staff_social c.l1.UiIND_weighted c.l1.UiIND_weighted#i.cost_enforce_top9 $l1x1)
	
	* ppmlhdfe without zeros
	ppmlhdfe CSR_staff_social c.l1.UiIND_weighted c.l1.UiIND_weighted $l1x1 if sample_ols_main_enforce09== 1 & CSR_staff_social!=0 & year == 2009, a(i.nic_industry i.state_code) vce(cluster co_code) d
	outreg2 using "${results_path}Table_4.tex", append addtext(Firm dummy, No, Industry dummy, Yes, State dummy, Yes)  ctitle(CSR in USD, ppml, cross section) addstat( "Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) dec(3) lab nocons  tex keep(CSR_staff_social c.l1.UiIND_weighted c.l1.UiIND_weighted $l1x1)
	
		ppmlhdfe CSR_staff_social c.l1.UiIND_weighted c.l1.UiIND_weighted#i.cost_enforce_median $l1x1 if sample_ols_main_enforce09== 1 & CSR_staff_social!=0 & year == 2009, a(i.nic_industry i.state_code) vce(cluster co_code) d
	outreg2 using "${results_path}Table_4.tex", append addtext(Firm dummy, No, Industry dummy, Yes, State dummy, Yes)  ctitle(CSR in USD, ppml, cross section) addstat( "Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) dec(3) lab nocons  tex keep(CSR_staff_social c.l1.UiIND_weighted c.l1.UiIND_weighted#i.cost_enforce_median $l1x1)
	
		ppmlhdfe CSR_staff_social c.l1.UiIND_weighted c.l1.UiIND_weighted#i.cost_enforce_top9 $l1x1 if CSR_staff_social!=0 & sample_ols_main_enforce09==1 & year == 2009, a(i.nic_industry i.state_code) vce(cluster co_code) d
	outreg2 using "${results_path}Table_4.tex", append addtext(Firm dummy, No, Industry dummy, Yes, State dummy, Yes)  ctitle(CSR in USD, ppml, cross section) addstat( "Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) dec(3) lab nocons  tex keep(CSR_staff_social c.l1.UiIND_weighted c.l1.UiIND_weighted#i.cost_enforce_top9 $l1x1)

	* ppmlhdfe with zeros
	ppmlhdfe CSR_staff_social c.l1.UiIND_weighted c.l1.UiIND_weighted $l1x1 if sample_ppml_main_enforce09==1 & year == 2009, a(i.nic_industry i.state_code) vce(cluster co_code) d
	outreg2 using "${results_path}Table_4.tex", append addtext(Firm dummy, No, Industry dummy, Yes, State dummy, Yes)  ctitle(CSR in USD, ppml, cross section)  addstat("Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) dec(3) lab nocons  tex keep(CSR_staff_social c.l1.UiIND_weighted c.l1.UiIND_weighted $l1x1)	
	
		ppmlhdfe CSR_staff_social c.l1.UiIND_weighted c.l1.UiIND_weighted#i.cost_enforce_median $l1x1 if sample_ppml_main_enforce09==1 & year == 2009, a(i.nic_industry i.state_code) vce(cluster co_code) d
	outreg2 using "${results_path}Table_4.tex", append addtext(Firm dummy, No, Industry dummy, Yes, State dummy, Yes)  ctitle(CSR in USD, ppml, cross section)  addstat("Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) dec(3) lab nocons  tex keep(CSR_staff_social c.l1.UiIND_weighted c.l1.UiIND_weighted#i.cost_enforce_median $l1x1)	
	
		ppmlhdfe CSR_staff_social c.l1.UiIND_weighted c.l1.UiIND_weighted#i.cost_enforce_top9 $l1x1 if sample_ppml_main_enforce09==1 & year == 2009, a(i.nic_industry i.state_code) vce(cluster co_code) d
	outreg2 using "${results_path}Table_4.tex", append addtext(Firm dummy, No, Industry dummy, Yes, State dummy, Yes)  ctitle(CSR in USD, ppml, cross section)  addstat("Number of clusters", e(N_clust), "Pseudo R$^2$", e(r2_p)) dec(3) lab nocons  tex keep(CSR_staff_social c.l1.UiIND_weighted c.l1.UiIND_weighted#i.cost_enforce_top9 $l1x1)	
	
	
	save "${data_path_prep}Total_merged_main_reg.dta", replace	

	

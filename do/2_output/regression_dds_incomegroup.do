/*******************************************************************************
Replication File for
- Extended Data Fig. 5 | Association between source-specific healthy household dietary diversity scores (HDDS) and household characteristics, by country income group. 
*******************************************************************************/

use "${datadir}/graphs and tables/regressions.dta", clear


// regressions
local n = 1
foreach vars of varlist DDS_hlthy DDS_hlthy_purch DDS_hlthy_own DDS_hlthy_rec {
	
	qui reg `vars' exp_ae_w_ln exp_ae_w_ln_sq i.education1 i.education2 i.education3 i.education4 hhsize age_hhh i.occup_agr_any i.sex_hhh i.urban i.month i.adm1_num
	gen esample = e(sample)
	
	* Reweighting
	gen w_new = wgt_raw if esample == 1
	bysort country: egen double mean_w_new = mean(w_new)
	replace w_new = mean_w_new if w_new == . & esample == 1

	bysort country: egen double all_obs = sum(w_new) if w_new != .
	gen wgt_new = .
	replace wgt_new = w_new*totpop/all_obs
	
	* Estimation 
	svyset psu [pw = wgt_new], strata(stratum) singleunit(centered)
	
	forv v = 2/4 {
		
		* Standardization
		foreach var of varlist `vars' exp_ae_w_ln exp_ae_w_ln_sq education1 education2 education3 education4 hhsize age_hhh age_hhh_sq occup_agr_any sex_hhh urban {
			center `var' [pw=wgt_new] if esample == 1 & WB_Incomegroup == `v', standardize gen(`var'_std) 
		}
		
		eststo reg`n'_`v'_stdout: svy: reg `vars'_std exp_ae_w_ln_std exp_ae_w_ln_sq_std education1_std education3_std education4_std hhsize_std age_hhh_std age_hhh_sq_std occup_agr_any_std sex_hhh_std urban_std i.month i.adm1_num	if WB_Incomegroup == `v'
		
		 drop *_std
	}
	
	* Miscallaneous
	drop wgt_new w_new esample mean_w_new all_obs esample
	local n = `n' + 1
}


*** Extended Data Fig. 5 
graph set window fontface "Helvetica" 

// Total HDDS
coefplot ///
	(reg1_2_stdout, label(HDDS) mcolor(midgreen*1.4) msymbol(T) ciopts(lcolor(midgreen*1.4)) ) ///
	(reg1_3_stdout, label(HDDS) mcolor(midgreen) msymbol(O) ciopts(lcolor(midgreen)) ) ///
	(reg1_4_stdout, label(HDDS) mcolor(midgreen*0.6) msymbol(D) ciopts(lcolor(midgreen*0.6)) ) ///
	, keep(DDS* exp_ae_w_ln_std *exp_ae_w_ln_sq_std *education?_std hhsize_std age_hhh_std age_hhh_sq_std *sex_hhh_std *urban_std *occup_agr_any_std) ylab(,labsize(7pt)) xlab(-4(2)4,labsize(7pt)) xline(0, lcol(black) lpattern(dash)) graphregion(margin(l-3) color(white))  ///
	mlabel(cond(@pval<.001, string(@b,"%9.3f") + "***", cond(@pval<.01, string(@b,"%9.3f") + "**", cond(@pval<.05, string(@b,"%9.3f") + "*", string(@b,"%9.3f"))))) ///
	format(%9.2f) mlabposition(2) mlabgap(*1) mlabsize(5pt) msize(vsmall) mlabcolor(black) msymbol(O) ysize(10cm) xsize(8.8cm) ///
	legend(order(2 "UMICs" 4 "LMICs" 6 "LICs") size(6pt) rows(1)) xtitle("Standardized Healthy HDDS", size(7pt)) ///
    coeflabels(                                            ///
        exp_ae_w_ln_std       = "Log cons./AE"             ///
        exp_ae_w_ln_sq_std    = "Log cons./AE (sq.)"       ///
        education1_std        = "Less than basic education"      ///
        education3_std        = "Intermediate education"         ///
        education4_std        = "Advanced education"                 ///
        hhsize_std            = "HH size"                  ///
        age_hhh_std           = "Head age"                 ///
        age_hhh_sq_std        = "Head age (sq.)"           ///
        occup_agr_any_std     = "Any agriculture"          ///
        sex_hhh_std           = "Female head"              ///
        urban_std             = "Urban"                    ///
		, labsize(7pt))  subtitle("{bf:a}", size(10pt) position(10))    name(g1, replace) nodraw
		

// Purchases HDDS
coefplot ///
	(reg2_2_stdout, label(HDDS) mcolor(midblue*1.4) msymbol(T) ciopts(lcolor(midblue*1.4)) ) ///
	(reg2_3_stdout, label(HDDS) mcolor(midblue) msymbol(O) ciopts(lcolor(midblue)) ) ///
	(reg2_4_stdout, label(HDDS) mcolor(midblue*0.6) msymbol(D) ciopts(lcolor(midblue*0.6)) ) ///
	, keep(DDS* exp_ae_w_ln_std *exp_ae_w_ln_sq_std *education?_std hhsize_std age_hhh_std age_hhh_sq_std *sex_hhh_std *urban_std *occup_agr_any_std) ylab(,labsize(7pt)) xlab(-4(2)4,labsize(7pt)) xline(0, lcol(black) lpattern(dash)) graphregion(margin(l-3) color(white))  ///
	mlabel(cond(@pval<.001, string(@b,"%9.3f") + "***", cond(@pval<.01, string(@b,"%9.3f") + "**", cond(@pval<.05, string(@b,"%9.3f") + "*", string(@b,"%9.3f"))))) ///
	format(%9.2f) mlabposition(2) mlabgap(*1) mlabsize(5pt) msize(vsmall) mlabcolor(black) msymbol(O) ysize(10cm) xsize(8.8cm) ///
	legend(order(2 "UMICs" 4 "LMICs" 6 "LICs") size(6pt) rows(1)) xtitle("Standardized Healthy HDDS from purchases", size(7pt)) ///
    coeflabels(                                            ///
        exp_ae_w_ln_std       = "Log cons./AE"             ///
        exp_ae_w_ln_sq_std    = "Log cons./AE (sq.)"       ///
        education1_std        = "Less than basic education"      ///
        education3_std        = "Intermediate education"         ///
        education4_std        = "Advanced education"                 ///
        hhsize_std            = "HH size"                  ///
        age_hhh_std           = "Head age"                 ///
        age_hhh_sq_std        = "Head age (sq.)"           ///
        occup_agr_any_std     = "Any agriculture"          ///
        sex_hhh_std           = "Female head"              ///
        urban_std             = "Urban"                    ///
		, labsize(7pt)) subtitle("{bf:b}", size(10pt) position(10))  name(g2, replace) nodraw
		

// Own consumption HDDS
coefplot ///
	(reg3_2_stdout, label(HDDS) mcolor(sienna*1.4) msymbol(T) ciopts(lcolor(sienna*1.4)) ) ///
	(reg3_3_stdout, label(HDDS) mcolor(sienna) msymbol(O) ciopts(lcolor(sienna)) ) ///
	(reg3_4_stdout, label(HDDS) mcolor(sienna*0.6) msymbol(D) ciopts(lcolor(sienna*0.6)) ) ///
	, keep(DDS* exp_ae_w_ln_std *exp_ae_w_ln_sq_std *education?_std hhsize_std age_hhh_std age_hhh_sq_std *sex_hhh_std *urban_std *occup_agr_any_std) ylab(,labsize(7pt)) xlab(-4(2)4,labsize(7pt)) xline(0, lcol(black) lpattern(dash)) graphregion(margin(l-3) color(white))  ///
	mlabel(cond(@pval<.001, string(@b,"%9.3f") + "***", cond(@pval<.01, string(@b,"%9.3f") + "**", cond(@pval<.05, string(@b,"%9.3f") + "*", string(@b,"%9.3f"))))) ///
	format(%9.2f) mlabposition(2) mlabgap(*1) mlabsize(5pt) msize(vsmall) mlabcolor(black) msymbol(O) ysize(10cm) xsize(8.8cm) ///
	legend(order(2 "UMICs" 4 "LMICs" 6 "LICs") size(6pt) rows(1)) xtitle("Standardized Healthy HDDS from own consumption", size(7pt)) ///
    coeflabels(                                            ///
        exp_ae_w_ln_std       = "Log cons./AE"             ///
        exp_ae_w_ln_sq_std    = "Log cons./AE (sq.)"       ///
        education1_std        = "Less than basic education"      ///
        education3_std        = "Intermediate education"         ///
        education4_std        = "Advanced education"                 ///
        hhsize_std            = "HH size"                  ///
        age_hhh_std           = "Head age"                 ///
        age_hhh_sq_std        = "Head age (sq.)"           ///
        occup_agr_any_std     = "Any agriculture"          ///
        sex_hhh_std           = "Female head"              ///
        urban_std             = "Urban"                    ///
		, labsize(7pt)) subtitle("{bf:c}", size(10pt) position(10))   name(g3, replace) nodraw
		
		
// Own consumption HDDS
coefplot ///
	(reg4_2_stdout, label(HDDS) mcolor(gold*1.4) msymbol(T) ciopts(lcolor(gold*1.4)) ) ///
	(reg4_3_stdout, label(HDDS) mcolor(gold) msymbol(O) ciopts(lcolor(gold)) ) ///
	(reg4_4_stdout, label(HDDS) mcolor(gold*0.6) msymbol(D) ciopts(lcolor(gold*0.6)) ) ///
	, keep(DDS* exp_ae_w_ln_std *exp_ae_w_ln_sq_std *education?_std hhsize_std age_hhh_std age_hhh_sq_std *sex_hhh_std *urban_std *occup_agr_any_std) ylab(,labsize(7pt)) xlab(-4(2)4,labsize(7pt)) xline(0, lcol(black) lpattern(dash)) graphregion(margin(l-3) color(white))  ///
	mlabel(cond(@pval<.001, string(@b,"%9.3f") + "***", cond(@pval<.01, string(@b,"%9.3f") + "**", cond(@pval<.05, string(@b,"%9.3f") + "*", string(@b,"%9.3f"))))) ///
	format(%9.2f) mlabposition(2) mlabgap(*1) mlabsize(5pt) msize(vsmall) mlabcolor(black) msymbol(O) ysize(10cm) xsize(8.8cm) ///
	legend(order(2 "UMICs" 4 "LMICs" 6 "LICs") size(6pt) rows(1)) xtitle("Standardized Healthy HDDS from gifts/in-kind", size(7pt)) ///
    coeflabels(                                            ///
        exp_ae_w_ln_std       = "Log cons./AE"             ///
        exp_ae_w_ln_sq_std    = "Log cons./AE (sq.)"       ///
        education1_std        = "Less than basic education"      ///
        education3_std        = "Intermediate education"         ///
        education4_std        = "Advanced education"                 ///
        hhsize_std            = "HH size"                  ///
        age_hhh_std           = "Head age"                 ///
        age_hhh_sq_std        = "Head age (sq.)"           ///
        occup_agr_any_std     = "Any agriculture"          ///
        sex_hhh_std           = "Female head"              ///
        urban_std             = "Urban"                    ///
		, labsize(7pt)) subtitle("{bf:d}", size(10pt) position(10))  name(g4, replace) nodraw
		
graph combine g1 g2 g3 g4, graphregion(margin(b-3 t-2) color(white)) ysize(20.5cm) xsize(18.0cm) rows(2) imargin(tiny)
graph export "${workdir}/graphs/DDS_reg_incgroup.png", replace
graph export "${workdir}/graphs/DDS_reg_incgroup.pdf", replace





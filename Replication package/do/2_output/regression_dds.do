/*******************************************************************************
Replication File for
- Fig. 6 | Association between source-specific healthy household dietary diversity scores (HDDS) and household demographic and socioeconomic characteristics. 
- Table S1 | Delta R-squared (ΔR²) by predictor and HDDS source of Fig. 6.
*******************************************************************************/

* Preparation
use "${datadir}/graphs and tables/regressions.dta", clear


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
	
	* Standardization
	foreach var of varlist `vars' exp_ae_w_ln exp_ae_w_ln_sq education1 education2 education3 education4 hhsize age_hhh age_hhh_sq occup_agr_any sex_hhh urban { 

		center `var' [pw=wgt_new] if esample == 1, standardize gen(`var'_std) sdsave(sd_`n'_`var')
	}
	
	eststo reg`n'_stdout: svy: reg `vars'_std exp_ae_w_ln_std exp_ae_w_ln_sq_std education1_std education3_std education4_std hhsize_std age_hhh_std age_hhh_sq_std occup_agr_any_std sex_hhh_std urban_std i.month i.adm1_num
	
	* Miscallaneous
	drop wgt_new w_new esample mean_w_new all_obs *_std
	local n = `n' + 1
}


	
/*------------------------------------------------------------------------------
Fig. 6 | Association between source-specific healthy household dietary diversity scores (HDDS) 
		and household demographic and socioeconomic characteristics. 
------------------------------------------------------------------------------*/	

local n = 1
foreach var of varlist exp_ae_w_ln exp_ae_w_ln_sq education1 education3 education4 hhsize age_hhh age_hhh_sq occup_agr_any sex_hhh urban {

	qui sum sd_3_`var'
	local sd3 : display %9.2f r(mean)
	local sd3 = strtrim(itrim("`sd3'"))
	qui sum sd_4_`var'
	local sd4 : display %9.2f r(mean)
	local sd4 = strtrim(itrim("`sd4'"))
	
	local textinput "`textinput' `n'.15 -3.3 "SD{subscript:1}=`sd3'" `n'.35 -3.3 "SD{subscript:2}=`sd4'""
	
	local n = `n' + 1
}

local n = 1
foreach var of varlist sd_1_DDS_hlthy sd_2_DDS_hlthy_purch sd_3_DDS_hlthy_own sd_4_DDS_hlthy_rec {

	qui sum `var'
	local sd`n' : display %9.2f r(mean)
	local sd`n' = strtrim(itrim("`sd`n''"))
	local n = `n' + 1
}

graph set window fontface "Helvetica" // add standard deviation of outcome variable
coefplot ///
	(reg1_stdout, label(HDDS (SD=`sd1')) mcolor(midgreen) ciopts(lcolor(midgreen)) ) ///
	(reg2_stdout, label(HDDS (purchases; SD=`sd2')) mcolor(midblue) ciopts(lcolor(midblue)) ) ///
	(reg3_stdout, label(HDDS (own consumption; SD=`sd3')) mcolor(sienna) ciopts(lcolor(sienna)) ) ///
	(reg4_stdout, label(HDDS (gifts/in-kind; SD=`sd4')) mcolor(gold) ciopts(lcolor(gold)) ) ///
	, keep(DDS* exp_ae_w_ln_std *exp_ae_w_ln_sq_std *education?_std hhsize_std age_hhh_std age_hhh_sq_std *sex_hhh_std *urban_std *occup_agr_any_std) ylab(,labsize(7pt)) xlab(,labsize(7pt)) xline(0, lcol(black) lpattern(dash)) graphregion(color(white))  ///
	mlabel(cond(@pval<.001, string(@b,"%9.3f") + "***", cond(@pval<.01, string(@b,"%9.3f") + "**", cond(@pval<.05, string(@b,"%9.3f") + "*", string(@b,"%9.3f"))))) ///
	format(%9.2f) mlabposition(3) mlabgap(*5) mlabsize(5pt) msize(small) mlabcolor(black) msymbol(O) ysize(12cm) xsize(8.8cm) ///
	legend(size(6pt) rows(2) bmargin(l-30) bexpand) ///
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
		, labsize(7pt) /*wrap(14)*/)                            ///
		text(`textinput', size(5pt))
graph export "${workdir}/graphs/DDS_reg.png", replace
graph export "${workdir}/graphs/DDS_reg.pdf", replace


/*------------------------------------------------------------------------------
	Table S1 | Delta R-squared (ΔR²) by predictor and HDDS source of Fig. 6.
------------------------------------------------------------------------------*/	

matrix DeltaR = J(10, 4, .)

cap drop  *_std
cap drop  sd_* 
cap drop wgt_new w_new esample mean_w_new all_obs esample

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
	
	eststo reg`n'_stdout: svy: reg `vars' exp_ae_w_ln exp_ae_w_ln_sq education1 education2 education3 education4 hhsize age_hhh age_hhh_sq occup_agr_any sex_hhh urban i.month i.adm1_num
	scalar R2_`n' = e(r2)
	
	* --------- Partial R^2 by blocks ----------
	// Cosnumption expenditure
	qui eststo reg`n'_stdout: svy: reg `vars' education1 education3 education4 hhsize age_hhh age_hhh_sq occup_agr_any sex_hhh urban i.month i.adm1_num
	scalar R2_`n'_1 = e(r2)
	// Education
	qui eststo reg`n'_stdout: svy: reg `vars' exp_ae_w_ln exp_ae_w_ln_sq hhsize age_hhh age_hhh_sq occup_agr_any sex_hhh urban i.month i.adm1_num
	scalar R2_`n'_2 = e(r2)
	// Household Size
	qui eststo reg`n'_stdout: svy: reg `vars' exp_ae_w_ln exp_ae_w_ln_sq education1 education3 education4 age_hhh age_hhh_sq occup_agr_any sex_hhh urban i.month i.adm1_num
	scalar R2_`n'_3 = e(r2)
	// Age household head
	qui eststo reg`n'_stdout: svy: reg `vars' exp_ae_w_ln exp_ae_w_ln_sq education1 education3 education4 hhsize occup_agr_any sex_hhh urban i.month i.adm1_num
	scalar R2_`n'_4 = e(r2)
	// Engagement in agriculture
	qui eststo reg`n'_stdout: svy: reg `vars' exp_ae_w_ln exp_ae_w_ln_sq education1 education3 education4 hhsize age_hhh age_hhh_sq sex_hhh urban i.month i.adm1_num
	scalar R2_`n'_5 = e(r2)
	di in red "Halfway"
	// Sex Household Head
	qui eststo reg`n'_stdout: svy: reg `vars' exp_ae_w_ln exp_ae_w_ln_sq education1 education3 education4 hhsize age_hhh age_hhh_sq occup_agr_any urban i.month i.adm1_num
	scalar R2_`n'_6 = e(r2)
	// Urban household
	qui eststo reg`n'_stdout: svy: reg `vars' exp_ae_w_ln exp_ae_w_ln_sq education1 education3 education4 hhsize age_hhh age_hhh_sq occup_agr_any sex_hhh i.month i.adm1_num
	scalar R2_`n'_7 = e(r2)
	// Month FE's 
	qui eststo reg`n'_stdout: svy: reg `vars' exp_ae_w_ln exp_ae_w_ln_sq education1 education3 education4 hhsize age_hhh age_hhh_sq occup_agr_any sex_hhh urban i.adm1_num
	scalar R2_`n'_8 = e(r2)
	// ADM1 FE's
	qui eststo reg`n'_stdout: svy: reg `vars' exp_ae_w_ln exp_ae_w_ln_sq education1 education3 education4 hhsize age_hhh age_hhh_sq occup_agr_any sex_hhh urban i.month
	scalar R2_`n'_9 = e(r2)
	
	forv v = 1/9 {
		matrix DeltaR[`v',`n'] = R2_`n'-R2_`n'_`v'
	}

	matrix DeltaR[10,`n'] = R2_`n'
    * -------------------------------------------------------------------------
	
	* Miscallaneous
	cap drop wgt_new w_new esample mean_w_new all_obs
	local n = `n' + 1
}


* open workbook
putexcel set "${workdir}/tables/partialR2_table.xlsx", replace sheet("DeltaR")

* header
putexcel A1=("Variable") B1=("HDDS") C1=("Purchases") D1=("Own cons.") E1=("Gifts-in-kind")

* write numeric matrix starting at B2
putexcel B2 = matrix(DeltaR)

putexcel A2 = "Consumption Expenditure" 
putexcel A3 = "Education" 
putexcel A4 = "Household Size" 
putexcel A5 = "Age household head" 
putexcel A6 = "Engagement in agriculture" 
putexcel A7 = "Sex Household Head" 
putexcel A8 = "Location" 
putexcel A9 = "Month FEs" 
putexcel A10 = "ADM1 FEs" 
putexcel A11 = "Full Model" 

* Format numbers to 3 decimals
putexcel B2:E11, nformat("0.000")

* Cosmetic: small font + bold header
putexcel A1:E11, font("Helvetica", 7)
putexcel A1:E1, bold
putexcel A11:E11, bold




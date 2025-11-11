/*******************************************************************************
Preparation for 
- Fig. 6 | Association between source-specific healthy household dietary diversity scores (HDDS) and household demographic and socioeconomic characteristics. 
- Table S1 | Delta R-squared (ΔR²) by predictor and HDDS source of Fig. 6.
- Fig. S22 | Association between source-specific MDDW and household demographic and socioeconomic characteristics. 
- Table S2 | Delta R-squared (ΔR²) by predictor and MDDW source of Fig. S21.
- Extended Data Fig. 5 | Association between source-specific healthy household dietary diversity scores (HDDS) and household characteristics, by country income group. 
*******************************************************************************/

use "${datadir}/processed_analysis.dta", clear
encode country, gen(country_enc)

lab var DDS_hlthy "Total HDDS (0-9)"
lab var DDS_hlthy_purch "HDDS (0-9) from purchases"
lab var DDS_hlthy_own "HDDS (0-9) from own consumption"
lab var DDS_hlthy_rec "HDDS (0-9) from gifts/in-kind"
lab var MDDW "Total MDDW (0-10)"
lab var MDDW_purch "MDDW (0-10) from purchases"
lab var MDDW_own "MDDW (0-10) from own consumption"
lab var MDDW_rec "MDDW (0-10) from gifts/in-kind"

gen exp_ae_w_ln = ln(exp_ae_w)
lab var exp_ae_w_ln "Cons. exp. per AE, log"

gen exp_ae_w_ln_sq = exp_ae_w_ln^2
lab var exp_ae_w_ln_sq "Cons. exp. per AE, log, squared"

gen age_hhh_sq = age_hhh^2
lab var age_hhh_sq "Age household head, squared"

gen hhsize_sq = hhsize^2
lab var hhsize_sq "Household size, squared"

lab def sex 1 "Female HHH" 2 "Female HHH", modify

replace urban = 1 if country == "Argentina" 

// Generate dummies
tab educ3, gen(education)

// adjust month variable
gen quarter = quarter(dofq(int_qtr))
replace month = 2 if quarter == 1 // assign circa month for quarter variables
replace month = 5 if quarter == 2 // assign circa month for quarter variables
replace month = 8 if quarter == 3 // assign circa month for quarter variables
replace month = 11 if quarter == 4 // assign circa month for quarter variables

replace month = 99 if month == . & inlist(country,"Angola","Bhutan","Kiribati","Tokelau") 

// Adjust ADM1 variable
egen adm1_num = group(surveyid adm1)

keep DDS_hlthy DDS_hlthy_purch DDS_hlthy_own DDS_hlthy_rec ///
	MDDW MDDW_purch MDDW_own MDDW_rec ///
	exp_ae_w_ln exp_ae_w_ln_sq ///
	education1 education2 education3 education4 ///
	hhsize hhsize_sq age_hhh age_hhh_sq occup_agr_any sex_hhh urban month adm1_num ///
	country totpop WB_Incomegroup psu stratum wgt_raw
	 
	 
save "$datadir/graphs and tables/regressions.dta", replace

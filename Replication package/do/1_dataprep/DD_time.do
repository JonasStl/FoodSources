/*******************************************************************************
Preparation for Fig. S15 | Development of healthy dietary diversity and sources over time
*******************************************************************************/
use "$datadir/processed_time.dta", clear
encode surveyid, gen(surveyid_enc)

preserve
collapse (firstnm) country year, by(surveyid_enc)

tempfile surveyinfo
save `surveyinfo'
restore

gen own_perc = round((DDS_hlthy_own/DDS_hlthy)*100)
replace own_perc = 0 if DDS_hlthy == 0 & DDS_hlthy_own == 0
gen purch_perc = round((DDS_hlthy_purch/DDS_hlthy)*100)
replace purch_perc = 0 if DDS_hlthy == 0 & DDS_hlthy_purch == 0
gen rec_perc = round((DDS_hlthy_rec/DDS_hlthy)*100)
replace rec_perc = 0 if DDS_hlthy == 0 & DDS_hlthy_rec == 0

local vars = "DDS_hlthy DDS_hlthy_purch DDS_hlthy_own DDS_hlthy_rec purch_perc own_perc rec_perc"
local vars_n: word count `vars'

gen insample = (DDS_hlthy < . & psu < . & stratum < . & wgt < .) 
bysort surveyid: egen double all_obs = sum(w_new) if w_new != . & insample == 1
gen wgt_new = .
replace wgt_new = w_new*totpop/all_obs

svyset psu [pw = wgt_new], strata(stratum) singleunit(centered)




levelsof surveyid_enc, local(lvls_svys)
local n_svys = r(r)
di = "`n_svys'"
di = "`vars_n'"
mat define M = J(`n_svys',(`vars_n'*4)+1,.)

foreach num of numlist `lvls_svys' {
	
	mat M[`num',1] = `num'	
}


local n = 1
local m = 2
foreach var of local vars {
	
	local `var'_lbl: var label `var'
	
	
	svy, subpop(insample): mean `var', over(surveyid_enc)
	/*
	Sample: 662,331
	*/
	mat define A`n' = r(table)
	mat define B`n' = A`n''
	
	levelsof surveyid_enc if insample == 1 & `var' < .
	local n_cntries_`var' = r(r)
	local lvls_cntries_`var' = "`r(levels)'"

	foreach num of numlist `lvls_cntries_`var'' {
		mat M[`num',`m'] = B`n'["c.`var'@`num'.surveyid_enc",1]
		mat M[`num',`m'+1] = B`n'["c.`var'@`num'.surveyid_enc",2]
		mat M[`num',`m'+2] = B`n'["c.`var'@`num'.surveyid_enc",5]
		mat M[`num',`m'+3] = B`n'["c.`var'@`num'.surveyid_enc",6]
	}
	
	di = "`colnames'"
	local colnames = "`colnames' `var' se_`var' ll_`var' ul_`var'"
	
	local n = `n' + 1
	local m = `m' + 4
}

drop _all
mat colnames M = surveyid_enc `colnames'
svmat M, names(col)

lab val surveyid_enc surveyid_enc
merge 1:1 surveyid_enc using `surveyinfo', nogen

foreach var of local vars {
	
	lab var `var' "`var'_lbl"
	lab var se_`var' "Standard Error: `var'_lbl"
	lab var se_`var' "Lower Limit 95% CI: `var'_lbl"
	lab var se_`var' "Upper Limit 95% CI: `var'_lbl"
	
}



gen purchperc = string(purch_perc, "%9.0f") + "%"
gen ownperc = string(own_perc, "%9.0f") + "%"
gen recperc = string(rec_perc, "%9.0f") + "%"

save "$datadir/graphs and tables/timetrends.dta", replace



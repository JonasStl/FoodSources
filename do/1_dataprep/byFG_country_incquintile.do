/*******************************************************************************
Preparation for 
- Fig. S6 | Food group consumption by country and expenditure quintile. 
*******************************************************************************/
use "$datadir/processed_analysis.dta", clear

encode country, gen(country_enc)

egen exp_pc_quint = xtile(exp_pc_day), by(surveyid) nq(5)

local vars = "HDDS_1 HDDS_2 HDDS_3 HDDS_4 HDDS_5 HDDS_6 HDDS_7 HDDS_8 HDDS_9"
local vars_n: word count `vars'
keep country country_enc wgt_raw stratum psu `vars' totpop surveyid w_new exp_pc_quint

gen insample = (HDDS_1 < . & exp_pc_quint < .)
bysort surveyid: egen double all_obs = sum(w_new) if w_new != . & insample == 1
gen wgt_new = .
replace wgt_new = w_new*totpop/all_obs

svyset psu [pw = wgt_new], strata(stratum) singleunit(centered)

levelsof country_enc if insample == 1, local(n_cntries)
local n_cntries = r(r)
local lvls_cntries = "`r(levels)'"
mat define M = J(`n_cntries'*5,(`vars_n'*4)+2,.)

local row = 1
foreach num of numlist `lvls_cntries' {
	
	forv n = 1/5 {
		
		mat M[`row',1] = `num'
		mat M[`row',2] = `n'
		
		local row = `row' + 1
	}
}

local n = 1
local m = 1
foreach var of local vars {
	
	local `var'_lbl: var label `var'	
	
	svy, subpop(insample): mean `var', over(country_enc exp_pc_quint)
	/*
	Sample:
	- 1,065,824
	
	*/
	mat define A`n' = r(table)
	mat define B`n' = A`n''
	
	local row = 1

	foreach num of numlist `lvls_cntries' {
		
		forv v = 1/5 {
				
			mat M[`row',`m'+2] = B`n'["c.`var'@`num'.country_enc#`v'.exp_pc_quint",1]
			mat M[`row',`m'+3] = B`n'["c.`var'@`num'.country_enc#`v'.exp_pc_quint",2]
			mat M[`row',`m'+4] = B`n'["c.`var'@`num'.country_enc#`v'.exp_pc_quint",5]
			mat M[`row',`m'+5] = B`n'["c.`var'@`num'.country_enc#`v'.exp_pc_quint",6]
			
			local row = `row' + 1
		}		
	}
	
	local colnames = "`colnames' `var' se_`var' ll_`var' ul_`var'"
	
	local n = `n' + 1
	local m = `m' + 4
}

drop _all
mat colnames M = _country exp_pc_quint `colnames'
svmat M, names(col)

lab val _country country_enc
decode _country, gen(country)

//labelling
foreach var of local vars {
	
	lab var `var' "``var'_lbl'"
	lab var se_`var' "Standard Error: ``var'_lbl'"
	lab var ll_`var' "Lower Limit 95% CI: ``var'_lbl'"
	lab var ul_`var' "Upper Limit 95% CI: ``var'_lbl'"
	
}

lab var country "Country & Year"
lab var _country "Country & Year"
lab var exp_pc_quint "Expenditure quintile (1=poorest, 5=richest)"

save "$datadir/graphs and tables/byFG_country_incquint.dta", replace



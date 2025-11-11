/*******************************************************************************
Preparation for 
- Table S4 | Summary Statistics.
*******************************************************************************/
use "${datadir}/processed_analysis.dta", clear

egen countryyear = concat(isocode year), punct(" ")
encode countryyear, gen(country_enc)

preserve
collapse (firstnm) country isocode headcount_IPL year totpop, by(countryyear)
ren country countryname
ren countryyear country

tempfile countryinfo
save `countryinfo'
restore

// code binary variables in percent
replace sex_hhh = 0 if sex_hhh == 2 | sex_hhh == 3
foreach var of varlist urban occup_agr_any sex_hhh {
	
	replace `var' = `var'*100 if `var' == 1
}

local vars = "onlypurch anypurch anyown anyrec purchindep urban exp_pc_day occup_agr_any hhsize adulteq sex_hhh educ3" 
local vars_n: word count `vars'
keep country country_enc hhid wgt_raw stratum psu `vars' DDS_hlthy totpop

levelsof country_enc, local(n_cntries)
local n_cntries = r(r)
local lvls_cntries = "`r(levels)'"
mat define M = J(`n_cntries',`vars_n'+1,.)

foreach num of numlist `lvls_cntries' {
	mat M[`num',1] = `num'
}

preserve

local n = 1
foreach var of local vars {
	
	local `var'_lbl: var label `var'
	
	restore
	preserve
	
	// reweight
	gen insample = (DDS_hlthy < . & `var' < .)
	gen w_new = wgt_raw if insample == 1
	bysort country: egen double mean_w_new = mean(w_new)
	replace w_new = mean_w_new if w_new == . & insample == 1

	bysort country: egen double all_obs = sum(w_new) if w_new != .
	gen wgt_new = .
	replace wgt_new = w_new*totpop/all_obs

	svyset psu [pw = wgt_new], strata(stratum) singleunit(centered)
	
	
	svy: mean `var', over(country_enc)
	mat define A`n' = r(table)
	mat define B`n' = A`n''
	
	levelsof country_enc if psu != . & `var' != .
	local n_cntries_`var' = r(r)
	local lvls_cntries_`var' = "`r(levels)'"

	foreach num of numlist `lvls_cntries_`var'' {
		mat M[`num',`n'+1] = B`n'["c.`var'@`num'.country_enc",1]
	}
	
	local n = `n' + 1
}
restore, not

drop _all
mat colnames M = _country `vars'
svmat M, names(col)

lab val _country country_enc
decode _country, gen(country)
merge 1:1 country using `countryinfo', nogen

foreach var of local vars {
	
	lab var `var' "`var'_lbl"
	
}

order country


* Export STATA data for maps
save "${datadir}/graphs and tables/cntrylvldata.dta", replace


/*******************************************************************************
Preparation for 
- Fig. 3 | Healthy household dietary diversity (9 food groups) by country.
- Fig. S12 | Relationship between total healthy dietary diversity (HDDS) and proportions from purchases and own consumption. 
*******************************************************************************/
use "$datadir/processed_analysis.dta", clear
egen countryyear = concat(country year), punct(" ")

gen own_perc = round((DDS_hlthy_own/DDS_hlthy)*100)
replace own_perc = 0 if DDS_hlthy == 0 & DDS_hlthy_own == 0
gen purch_perc = round((DDS_hlthy_purch/DDS_hlthy)*100)
replace purch_perc = 0 if DDS_hlthy == 0 & DDS_hlthy_purch == 0

lab var purch_perc "Share of HDDS covered through purchases"
lab var own_perc "Share of HDDS covered through own consumption"
lab var onlypurch "Consumed only from purchases"
replace onlypurch = 0 if anypurch < . & inlist(country,"Ghana","Bhutan","Rwanda","Cook Island")
replace onlypurch = 100 if anypurch == 100 & anyown == 0 & inlist(country,"Ghana","Bhutan","Rwanda","Cook Island")

sencode countryyear, gen(country_enc) gsort(mean_consexp_pip)

local vars = "DDS_hlthy DDS_hlthy_purch DDS_hlthy_own purch_perc own_perc anyown onlypurch"
local vars_n: word count `vars'
keep country country_enc hhid wgt_raw stratum psu `vars' totpop surveyid w_new

gen insample = (DDS_hlthy < . & DDS_hlthy_purch < . & DDS_hlthy_own < .) 
bysort surveyid: egen double all_obs = sum(w_new) if w_new != . & insample == 1
gen wgt_new = .
replace wgt_new = w_new*totpop/all_obs

svyset psu [pw = wgt_new], strata(stratum) singleunit(centered)


levelsof country_enc, local(n_cntries)
local n_cntries = r(r)
local lvls_cntries = "`r(levels)'"
mat define M = J(`n_cntries',(`vars_n'*4)+1,.)

foreach num of numlist `lvls_cntries' {
	mat M[`num',1] = `num'
}


local n = 1
local m = 1
foreach var of local vars {
	
	local `var'_lbl: var label `var'	
	
	svy, subpop(insample): mean `var', over(country_enc)
	/*
	Sample:
	- 1,107,826 HHs, representative of 2,872,717,209 people
	*/
	mat define A`n' = r(table)
	mat define B`n' = A`n''
	
	levelsof country_enc if psu != . & `var' != .
	local n_cntries_`var' = r(r)
	local lvls_cntries_`var' = "`r(levels)'"

	foreach num of numlist `lvls_cntries_`var'' {
		mat M[`num',`m'+1] = B`n'["c.`var'@`num'.country_enc",1]
		mat M[`num',`m'+2] = B`n'["c.`var'@`num'.country_enc",2]
		mat M[`num',`m'+3] = B`n'["c.`var'@`num'.country_enc",5]
		mat M[`num',`m'+4] = B`n'["c.`var'@`num'.country_enc",6]
	}
	
	local colnames = "`colnames' `var' se_`var' ll_`var' ul_`var'"
	
	local n = `n' + 1
	local m = `m' + 4
}

drop _all
mat colnames M = _country `colnames'
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


gen purchperc = string(round(purch_perc)) + "%"
gen ownperc = string(round(own_perc)) + "%"

lab var purchperc "Share of HDDS covered through purchases"
lab var ownperc "Share of HDDS covered through own consumption"


lab var country "Country & Year"
lab var _country "Country & Year"

save "$datadir/graphs and tables/DD_country.dta", replace




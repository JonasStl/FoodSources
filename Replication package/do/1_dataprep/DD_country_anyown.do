/*******************************************************************************
Preparation for 
- Fig. S11 | Country-level dietary diversity and sourcing by household own-consumption status. 
*******************************************************************************/
use "$datadir/processed_analysis.dta", clear

egen countryyear = concat(country year), punct(" ")
replace anyown = 1 if anyown == 100

gen own_perc = round((DDS_hlthy_own/DDS_hlthy)*100)
replace own_perc = 0 if DDS_hlthy == 0 & DDS_hlthy_own == 0
gen purch_perc = round((DDS_hlthy_purch/DDS_hlthy)*100)
replace purch_perc = 0 if DDS_hlthy == 0 & DDS_hlthy_purch == 0
gen gifts_perc = round((DDS_hlthy_rec/DDS_hlthy)*100)
replace gifts_perc = 0 if DDS_hlthy == 0 & DDS_hlthy_rec == 0

lab var purch_perc "Share of HDDS covered through purchases"
lab var own_perc "Share of HDDS covered through own consumption"
lab var gifts_perc "Share of HDDS covered through gifts/in-kind"

sencode countryyear, gen(country_enc) gsort(mean_consexp_pip) 


local vars = "DDS_hlthy DDS_hlthy_purch DDS_hlthy_own DDS_hlthy_rec purch_perc own_perc gifts_perc"
local vars_n: word count `vars'
keep country country_enc hhid stratum psu `vars' totpop surveyid w_new anyown

gen insample = (DDS_hlthy < . & DDS_hlthy_purch < . & DDS_hlthy_own < . & anyown <.) 
bysort surveyid: egen double all_obs = sum(w_new) if w_new != . & insample == 1
gen wgt_new = .
replace wgt_new = w_new*totpop/all_obs

svyset psu [pw = wgt_new], strata(stratum) singleunit(centered)

levelsof country_enc, local(n_cntries)
local n_cntries = r(r)
local lvls_cntries = "`r(levels)'"
mat define M = J(`n_cntries'*2,(`vars_n'*4)+2,.)

local v = 1
local n = 0
foreach num of numlist `lvls_cntries' {
	
	mat M[`v',1] = `num'
	mat M[`v'+1,1] = `num'
	
	mat M[`v',2] = `n'
	mat M[`v'+1,2] = `n'+1
	
	local v = `v' + 2
}

local n = 1
local m = 1
foreach var of local vars {
	
	local `var'_lbl: var label `var'	
	
	svy, subpop(insample): mean `var', over(country_enc anyown)
	/*
	Sample:
	- Dietary diversity, purchases, own consumption: 1,107,826 HHs, representative of 2,872,717,209 people
	- Gifts/in-kind: 774,501 HH, representative of 2,560,280,767 people
	*/
	mat define A`n' = r(table)
	mat define B`n' = A`n''
	
	levelsof country_enc if psu != . & `var' != .
	local n_cntries_`var' = r(r)
	local lvls_cntries_`var' = "`r(levels)'"

	foreach num of numlist `lvls_cntries_`var'' {
		mat M[`num'*2-1,`m'+2] = B`n'["c.`var'@`num'.country_enc#0.anyown",1]
		mat M[`num'*2-1,`m'+3] = B`n'["c.`var'@`num'.country_enc#0.anyown",2]
		mat M[`num'*2-1,`m'+4] = B`n'["c.`var'@`num'.country_enc#0.anyown",5]
		mat M[`num'*2-1,`m'+5] = B`n'["c.`var'@`num'.country_enc#0.anyown",6]
		
		mat M[`num'*2,`m'+2] = B`n'["c.`var'@`num'.country_enc#1.anyown",1]
		mat M[`num'*2,`m'+3] = B`n'["c.`var'@`num'.country_enc#1.anyown",2]
		mat M[`num'*2,`m'+4] = B`n'["c.`var'@`num'.country_enc#1.anyown",5]
		mat M[`num'*2,`m'+5] = B`n'["c.`var'@`num'.country_enc#1.anyown",6]
		
	}
	
	local colnames = "`colnames' `var' se_`var' ll_`var' ul_`var'"
	
	local n = `n' + 1
	local m = `m' + 4
}

drop _all
mat colnames M = _country anyown `colnames'
svmat M, names(col)

lab val _country country_enc
decode _country, gen(country)
lab def anyown 0 "NoOwnCons" 1 "AnyOwnCons"
lab val anyown anyown

//labelling
foreach var of local vars {
	
	lab var `var' "``var'_lbl'"
	lab var se_`var' "Standard Error: ``var'_lbl'"
	lab var ll_`var' "Lower Limit 95% CI: ``var'_lbl'"
	lab var ul_`var' "Upper Limit 95% CI: ``var'_lbl'"
	
}

lab var country "Country & Year"
lab var _country "Country & Year"
lab var anyown "Any own consumption"

gen purchperc = string(round(purch_perc)) + "%"
gen ownperc = string(round(own_perc)) + "%"
gen giftsperc = string(round(gifts_perc)) + "%"
lab var purchperc "Share of consumers who purchase FG (in %)"
lab var ownperc "Share of consumers who own consume FG (in %)"
lab var giftsperc "Share of consumers who receive FG from gifts/in-kind (in %)"


save "$datadir/graphs and tables/DD_bycountry_anyown.dta", replace


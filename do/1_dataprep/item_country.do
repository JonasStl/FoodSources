/*******************************************************************************
Preparation for 
- Fig. S14 | Food item sources by country. 
*******************************************************************************/
use "$datadir/processed_analysis.dta", clear
drop if country == "Rwanda" | country == "Indonesia" | country == "Ghana" 

egen countryyear = concat(country year), punct(" ")

sencode countryyear, gen(country_enc) gsort(mean_consexp_pip)

* Calculate totals
egen Ncons_hlthy = rowtotal(HDDS_1_Ncons HDDS_2_Ncons HDDS_3_Ncons HDDS_4_Ncons HDDS_5_Ncons HDDS_6_Ncons HDDS_7_Ncons HDDS_8_Ncons HDDS_9_Ncons), missing
egen Ncons_purch = rowtotal(HDDS_1_Ncons_purch HDDS_2_Ncons_purch HDDS_3_Ncons_purch HDDS_4_Ncons_purch HDDS_5_Ncons_purch HDDS_6_Ncons_purch HDDS_7_Ncons_purch HDDS_8_Ncons_purch HDDS_9_Ncons_purch), missing
egen Ncons_own = rowtotal(HDDS_1_Ncons_own HDDS_2_Ncons_own HDDS_3_Ncons_own HDDS_4_Ncons_own HDDS_5_Ncons_own HDDS_6_Ncons_own HDDS_7_Ncons_own HDDS_8_Ncons_own HDDS_9_Ncons_own), missing
egen Ncons_rec = rowtotal(HDDS_1_Ncons_rec HDDS_2_Ncons_rec HDDS_3_Ncons_rec HDDS_4_Ncons_rec HDDS_5_Ncons_rec HDDS_6_Ncons_rec HDDS_7_Ncons_rec HDDS_8_Ncons_rec HDDS_9_Ncons_rec), missing

gen Ncons_purch_shr = (Ncons_purch/Ncons_hlthy)*100
gen Ncons_own_shr = (Ncons_own/Ncons_hlthy)*100
gen Ncons_rec_shr = (Ncons_rec/Ncons_hlthy)*100


local vars = "Ncons_purch_shr Ncons_own_shr Ncons_rec_shr"
local vars_n: word count `vars'
keep country country_enc hhid wgt_raw stratum psu `vars' totpop surveyid w_new

gen insample = (Ncons_purch_shr < . & Ncons_own_shr < .) 
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
	- 778,158 HHs for purchases and own consumption
	- 768,736 HHs for gifts/in-kind
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
	
	di = "`colnames'"
	local colnames = "`colnames' `var' se_`var' ll_`var' ul_`var'"
	
	local n = `n' + 1
	local m = `m' + 4
}

drop _all
mat colnames M = _country `colnames'
svmat M, names(col)

lab val _country country_enc
decode _country, gen(country)



gen zero = 0
gen purchperc = string(round(Ncons_purch_shr)) + "%"
gen ownperc = string(round(Ncons_own_shr)) + "%"
gen recperc = string(round(Ncons_rec_shr)) + "%"

//labelling
lab var _country "country & year"
lab var Ncons_purch_shr "Item diversity from purchases"
lab var ll_Ncons_purch_shr "Lower limit 95% CI (purchases)"
lab var ul_Ncons_purch_shr "Upper limit 95% CI (purchases)"
lab var Ncons_own_shr "Item diversity from own consumption"
lab var ll_Ncons_own_shr "Lower limit 95% CI (own consumption)"
lab var ul_Ncons_own_shr "Upper limit 95% CI (own consumption)"
lab var Ncons_rec_shr "Item diversity from gifts/in-kind"
lab var ll_Ncons_rec_shr "Lower limit 95% CI (gifts/in-kind)"
lab var ul_Ncons_rec_shr "Upper limit 95% CI (gifts/in-kind)"
lab var purchperc "Share of HDDS that can be covered through purchases"
lab var ownperc "Share of HDDS that can be covered through own consumption"
lab var recperc "Share of HDDS that can be covered through gifts/in-kind"


save "$datadir/graphs and tables/items_country.dta", replace


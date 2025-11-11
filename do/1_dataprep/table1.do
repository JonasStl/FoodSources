/*******************************************************************************
Preparation for 
- Table 1 | Consumption of foods from purchases and own production by country.
*******************************************************************************/
use "${datadir}/processed_analysis.dta", clear

gen insample = (DDS_hlthy < . & DDS_hlthy_purch < . & DDS_hlthy_own < .) 
bysort surveyid: egen double all_obs = sum(w_new) if w_new != . & insample == 1
gen wgt_new = .
replace wgt_new = w_new*totpop/all_obs

svyset psu [pw = wgt_new], strata(stratum) singleunit(centered)

svy, subpop(insample): mean anyown
mat define A1 = r(table)
mat define B1 = A1'
mat define B1 = B1[1,1..2], B1[1,5..6]
mat colnames B1 = anyown se_anyown ll_anyown ul_anyown

svy, subpop(insample): mean onlypurch
mat define A2 = r(table)
mat define B2 = A2'
mat define B2 = B2[1,1..2],B2[1,5..6]
mat colnames B2 = onlypurch se_onlypurch ll_onlypurch ul_onlypurch

mat define C = B1,B2
drop _all

svmat C, names(col)

gen country = "Full Sample"

tempfile world
save `world'


* Country-level
use "${datadir}/graphs and tables/DD_country.dta", clear
keep country anyown se_anyown ll_anyown ul_anyown onlypurch se_onlypurch ll_onlypurch ul_onlypurch
sort country

append using `world'

save "$datadir/graphs and tables/table1.dta", replace

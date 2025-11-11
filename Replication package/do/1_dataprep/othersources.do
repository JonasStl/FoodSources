/*******************************************************************************
Preparation for 
- Fig. S4 | Consumption from disaggregated food sources. 
*******************************************************************************/
use "$datadir/processed_analysis.dta", clear
keep if inlist(country,"Armenia","Suriname","Barbados","Dominican Republic","India")

foreach var of varlist DDS_DOM_* DDS_BRB_* DDS_ARM_* DDS_SUR_* DDS_IND_* DDS_hlthy_purch {
	gen `var'_bin = .
	replace `var'_bin = 0 if `var' == 0
	replace `var'_bin = 100 if inrange(`var',1,9)
}

gen DDS_BRB_purch_bin = DDS_hlthy_purch_bin if country == "Barbados"
gen DDS_SUR_purch_bin = DDS_hlthy_purch_bin if country == "Suriname"


gen insample = (HDDS_1 < . ) 
bysort surveyid: egen double all_obs = sum(w_new) if w_new != . & insample == 1
gen wgt_new = .
replace wgt_new = w_new*totpop/all_obs

//analysis
svyset psu [pw = wgt_new], strata(stratum) singleunit(centered)

mat define M = J(5,1,.)

local n = 1
forv v = 1/5 {
	
	mat M[`v',1] = `v'

}
mat colnames M = country

* Dominican Republic
svy, subpop(insample): mean DDS_DOM_purch1_bin DDS_DOM_own1_bin DDS_DOM_ownshop_bin DDS_DOM_inkindpay_bin DDS_DOM_giftfor_bin DDS_DOM_giftdom_bin DDS_DOM_giftNGO_bin DDS_DOM_giftInstPub_bin DDS_DOM_transferInstPub_bin DDS_DOM_giftcom_bin

mat define A1 = r(table)
mat define B1 = J(1,1,e(N))
mat define M1 = A1[1,1..10],B1

* Armenia
svy, subpop(insample): mean DDS_ARM_purch1_bin DDS_ARM_own1_bin DDS_ARM_preservown_bin DDS_ARM_preservpurch_bin DDS_ARM_remuninkind_bin DDS_ARM_gift_bin DDS_ARM_humassist_bin DDS_ARM_hunt_bin

mat define A2 = r(table)
mat define B2 = J(1,1,e(N))
mat define M2 = A2[1,1..8],B2

* Suriname
svy, subpop(insample): mean DDS_SUR_purch_bin DDS_SUR_selfprod_bin DDS_SUR_selfsup_bin DDS_SUR_gift_bin DDS_SUR_recgov_bin DDS_SUR_recchurch_bin DDS_SUR_inkindpay_bin DDS_SUR_other_bin

mat define A3 = r(table)
mat define B3 = J(1,1,e(N))
mat define M3 = A3[1,1..8],B3

* Barbados
svy, subpop(insample): mean DDS_BRB_purch_bin DDS_BRB_selfprod_bin DDS_BRB_selfsup_bin DDS_BRB_gift_bin DDS_BRB_recgov_bin DDS_BRB_recchurch_bin DDS_BRB_inkindpay_bin DDS_BRB_other_bin

mat define A4 = r(table)
mat define B4 = J(1,1,e(N))
mat define M4 = A4[1,1..8],B4

* India
svy, subpop(insample): mean DDS_IND_purch_bin DDS_IND_subPDS_bin DDS_IND_purchown_bin DDS_IND_own_bin DDS_IND_collect_bin DDS_IND_exch_bin DDS_IND_gift_bin DDS_IND_freePDS_bin DDS_IND_other_bin

mat define A5 = r(table)
mat define B5 = J(1,1,e(N))
mat define M5 = A5[1,1..9],B5

* Combine
mat M = M1, M2, M3, M4, M5

drop _all
svmat M

local n = 1
foreach var in /* DomRep */ DDS_DOM_purch1_bin DDS_DOM_own1_bin DDS_DOM_ownshop_bin DDS_DOM_inkindpay_bin DDS_DOM_giftfor_bin DDS_DOM_giftdom_bin DDS_DOM_giftNGO_bin DDS_DOM_giftInstPub_bin DDS_DOM_transferInstPub_bin DDS_DOM_giftcom_bin DOM_sample ///
			/* Armenia */ DDS_ARM_purch1_bin DDS_ARM_own1_bin DDS_ARM_preservown_bin DDS_ARM_preservpurch_bin DDS_ARM_remuninkind_bin DDS_ARM_gift_bin DDS_ARM_humassist_bin DDS_ARM_hunt_bin ARM_sample ///
			/* Suriname */ DDS_SUR_purch_bin DDS_SUR_selfprod_bin DDS_SUR_selfsup_bin DDS_SUR_gift_bin DDS_SUR_recgov_bin DDS_SUR_recchurch_bin DDS_SUR_inkindpay_bin DDS_SUR_other_bin SUR_sample ///
			/* Barbados */ DDS_BRB_purch_bin DDS_BRB_selfprod_bin DDS_BRB_selfsup_bin DDS_BRB_gift_bin DDS_BRB_recgov_bin DDS_BRB_recchurch_bin DDS_BRB_inkindpay_bin DDS_BRB_other_bin BRB_sample ///
			/* India */ DDS_IND_purch_bin DDS_IND_subPDS_bin DDS_IND_purchown_bin DDS_IND_own_bin DDS_IND_collect_bin DDS_IND_exch_bin DDS_IND_gift_bin DDS_IND_freePDS_bin DDS_IND_other_bin IND_sample {
				
			ren M`n' `var'
				
			local n = `n' + 1
}


save "$datadir/graphs and tables/othersources.dta", replace

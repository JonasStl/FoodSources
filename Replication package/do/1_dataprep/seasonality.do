/*******************************************************************************
Preparation for 
- Fig. S16 | Monthly household dietary diversity score (HDDS) and sourcing in eleven countries. 
- Fig. S17 | Food item sourcing by month in eleven countries. 
- Fig. S18 | Seasonality in household consumption of selected food groups by source. 
*******************************************************************************/
use "$datadir/processed_analysis.dta", clear

* Keep eligible for season
/*
- 1.) Data in every month
- 2.) No less than 100 observations in each month to produce reliable estimates
- 3.) Rural/Urban differences are always within +-10 percentage points of annual mean
*/

* 1.) & 2.)
bysort country month: egen obs_month = count(DDS_hlthy) if month < . //Count number of observations by month
bysort country: egen obs_month_min = min(obs_month)
unique month if month < ., by(country) gen(n_months) //check if all months are there

tab country if obs_month_min > 100 & obs_month_min < . & n_months == 12 // countries with at least 100 observations with in a month (some small Pacific Islands have less which leads to unreliable estimates)
gen keep1 = 1 if obs_month_min > 100 & obs_month_min < . & n_months == 12
bysort country: egen keep2 = max(keep1)

* 3.) Rural/Urban differences are always within +-10 percentage points of annual mean
bysort country: egen urban_mean = mean(urban)
gen ll_urban_mean = urban_mean - 0.1
gen ul_urban_mean = urban_mean + 0.1
bysort country month: egen urban_monthmean = mean(urban) if month < .
gen keep3 = .
replace keep3 = 0 if urban_monthmean < ll_urban_mean | (urban_monthmean > ul_urban_mean & urban_monthmean < .)
replace keep3 = 1 if urban_monthmean >= ll_urban_mean & urban_monthmean <= ul_urban_mean 
bysort country: egen keep4 = min(keep3)
tab country keep4, m

keep if (keep2 == 1 & keep4 == 1) 
drop obs_month obs_month_min keep1 keep2 keep3 keep4 urban_mean ll_urban_mean ul_urban_mean urban_monthmean
bysort country: tab month urban


* Calculate food item variety
egen Ncons_hlthy = rowtotal(HDDS_1_Ncons HDDS_2_Ncons HDDS_3_Ncons HDDS_4_Ncons HDDS_5_Ncons HDDS_6_Ncons HDDS_7_Ncons HDDS_8_Ncons HDDS_9_Ncons), missing
egen Ncons_purch = rowtotal(HDDS_1_Ncons_purch HDDS_2_Ncons_purch HDDS_3_Ncons_purch HDDS_4_Ncons_purch HDDS_5_Ncons_purch HDDS_6_Ncons_purch HDDS_7_Ncons_purch HDDS_8_Ncons_purch HDDS_9_Ncons_purch), missing
egen Ncons_own = rowtotal(HDDS_1_Ncons_own HDDS_2_Ncons_own HDDS_3_Ncons_own HDDS_4_Ncons_own HDDS_5_Ncons_own HDDS_6_Ncons_own HDDS_7_Ncons_own HDDS_8_Ncons_own HDDS_9_Ncons_own), missing
egen Ncons_rec = rowtotal(HDDS_1_Ncons_rec HDDS_2_Ncons_rec HDDS_3_Ncons_rec HDDS_4_Ncons_rec HDDS_5_Ncons_rec HDDS_6_Ncons_rec HDDS_7_Ncons_rec HDDS_8_Ncons_rec HDDS_9_Ncons_rec), missing

gen Ncons_purch_shr = (Ncons_purch/Ncons_hlthy)*100
gen Ncons_own_shr = (Ncons_own/Ncons_hlthy)*100
gen Ncons_rec_shr = (Ncons_rec/Ncons_hlthy)*100

lab var Ncons_purch_shr "Proportion of food items consumed from purchases"
lab var Ncons_own_shr "Proportion of food items consumed from own production"
lab var Ncons_rec_shr "Proportion of food items consumed from gifts/in-kind"

* Food group consumption
//consumption
gen HDDS_6789 = .
replace HDDS_6789 = 0 if HDDS_6 == 0 & HDDS_7 == 0 & HDDS_8 == 0 & HDDS_9 == 0
replace HDDS_6789 = 100 if HDDS_6 == 100 | HDDS_7 == 100 | HDDS_8 == 100 | HDDS_9 == 100
//purchases
gen HDDS_6789_purch = .
replace HDDS_6789_purch = 0 if HDDS_6_purch == 0 & HDDS_7_purch == 0 & HDDS_8_purch == 0 & HDDS_9_purch == 0
replace HDDS_6789_purch = 100 if HDDS_6_purch == 100 | HDDS_7_purch == 100 | HDDS_8_purch == 100 | HDDS_9_purch == 100
//own consumption
gen HDDS_6789_own = .
replace HDDS_6789_own = 0 if HDDS_6_own == 0 & HDDS_7_own == 0 & HDDS_8_own == 0 & HDDS_9_own == 0
replace HDDS_6789_own = 100 if HDDS_6_own == 100 | HDDS_7_own == 100 | HDDS_8_own == 100 | HDDS_9_own == 100

lab var HDDS_6789 "Consumption of animal-source foods"
lab var HDDS_6789_purch "Consumption of animal-source foods from purchases"
lab var HDDS_6789_own "Consumption of animal-source foods from own production"

* Relevant variables
encode country, gen(country_enc)

* Calculate dietary diversity shares
gen own_perc = round((DDS_hlthy_own/DDS_hlthy)*100)
replace own_perc = 0 if DDS_hlthy == 0 & DDS_hlthy_own == 0
gen purch_perc = round((DDS_hlthy_purch/DDS_hlthy)*100)
replace purch_perc = 0 if DDS_hlthy == 0 & DDS_hlthy_purch == 0
gen gifts_perc = round((DDS_hlthy_rec/DDS_hlthy)*100)
replace gifts_perc = 0 if DDS_hlthy == 0 & DDS_hlthy_rec == 0

lab var purch_perc "Share of HDDS covered through purchases"
lab var own_perc "Share of HDDS covered through own consumption"
lab var gifts_perc "Share of HDDS covered through gifts/in-kind"

local vars = "DDS_hlthy DDS_hlthy_purch DDS_hlthy_own DDS_hlthy_rec purch_perc own_perc gifts_perc HDDS_4 HDDS_5 HDDS_6789 HDDS_4_purch HDDS_5_purch HDDS_6789_purch HDDS_4_own HDDS_5_own HDDS_6789_own Ncons_purch_shr Ncons_own_shr Ncons_rec_shr "
local vars_n: word count `vars'
keep country country_enc wgt_raw stratum psu `vars' totpop surveyid w_new month

gen insample = (DDS_hlthy < . & month <.)
bysort surveyid: egen double all_obs = sum(w_new) if w_new != . & insample == 1
gen wgt_new = .
replace wgt_new = w_new*totpop/all_obs

svyset psu [pw = wgt_new], strata(stratum) singleunit(centered)

levelsof country_enc, local(n_cntries)
local n_cntries = r(r)
local lvls_cntries = "`r(levels)'"
mat define M = J(`n_cntries'*12,(`vars_n'*4)+2,.)

local row = 1
foreach num of numlist `lvls_cntries' {
	
	forv n = 1/12 {
		
		mat M[`row',1] = `num'
		mat M[`row',2] = `n'
		
		local row = `row' + 1
	}
}

local n = 1
local m = 1
foreach var of local vars {
	
	local `var'_lbl: var label `var'	
	
	svy, subpop(insample): mean `var', over(country_enc month)
	/*
	Sample:
	- Own consumption: 228,651
	- Gifts/In-kind: 225,822
	*/
	mat define A`n' = r(table)
	mat define B`n' = A`n''
	
	local row = 1

	foreach num of numlist `lvls_cntries' {
		
		forv v = 1/12 {
				
			mat M[`row',`m'+2] = B`n'["c.`var'@`num'.country_enc#`v'.month",1]
			mat M[`row',`m'+3] = B`n'["c.`var'@`num'.country_enc#`v'.month",2]
			mat M[`row',`m'+4] = B`n'["c.`var'@`num'.country_enc#`v'.month",5]
			mat M[`row',`m'+5] = B`n'["c.`var'@`num'.country_enc#`v'.month",6]
			
			local row = `row' + 1
		}		
	}
	
	local colnames = "`colnames' `var' se_`var' ll_`var' ul_`var'"
	
	local n = `n' + 1
	local m = `m' + 4
}

drop _all
mat colnames M = _country month `colnames'
svmat M, names(col)

lab val _country country_enc
decode _country, gen(country)
lab val month mth

//labelling
foreach var of local vars {
	
	lab var `var' "``var'_lbl'"
	lab var se_`var' "Standard Error: ``var'_lbl'"
	lab var ll_`var' "Lower Limit 95% CI: ``var'_lbl'"
	lab var ul_`var' "Upper Limit 95% CI: ``var'_lbl'"
	
}

lab var country "Country & Year"
lab var _country "Country & Year"
lab var month "Month"


save "$datadir/graphs and tables/seasonality.dta", replace



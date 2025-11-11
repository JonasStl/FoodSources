/*******************************************************************************
Preparation for 
- Fig. S3 | Sourcing of food items by food group. 
*******************************************************************************/
use "$datadir/processed_analysis.dta", clear

drop if country == "Indonesia" // number of items only available for purchases

forv n = 1/12 {
	gen Ncons_shr_purch_`n' = (HDDS_`n'_Ncons_purch/HDDS_`n'_Ncons)*100
	gen Ncons_shr_own_`n' = (HDDS_`n'_Ncons_own/HDDS_`n'_Ncons)*100
	gen Ncons_shr_rec_`n' = (HDDS_`n'_Ncons_rec/HDDS_`n'_Ncons)*100
}



gen insample = (Ncons_shr_purch_1 < . ) 
bysort surveyid: egen double all_obs = sum(w_new) if w_new != . & insample == 1
gen wgt_new = .
replace wgt_new = w_new*totpop/all_obs

svyset psu [pw = wgt_new], strata(stratum) singleunit(centered)

mat define M = J(12,1,.)

forv v = 1/12 {
	
	mat M[`v',1] = `v'
	}
mat colnames M = _Foodgroup

local n = 1
local m = 1
foreach var in purch own rec {
	
	forv v = 1/12 {
		
		svy, subpop(insample): mean Ncons_shr_`var'_`v'

		mat define A`n'_`v' = r(table)
		mat define B`n'_`v' = A`n'_`v''
		mat define C`n'_`v' = J(1,1,e(N))
		mat define M`n'_`v' = B`n'_`v'[1,1..2], B`n'_`v'[1,5..6], C`n'_`v'
	}
	
	mat M`n' = M`n'_1 \ M`n'_2 \ M`n'_3 \ M`n'_4 \ M`n'_5 \ M`n'_6 \ M`n'_7 \ M`n'_8 \ M`n'_9 \ M`n'_10 \ M`n'_11 \ M`n'_12
	
	mat colnames M`n' = Ncons_shr_`var' se_Ncons_shr_`var' ll_Ncons_shr_`var' ul_Ncons_shr_`var' sample_`var'
	
	local n = `n' + 1
}

mat X = M, M1, M2, M3

drop _all

svmat X, names(col)

lab define foodgroups 1 "Cereals" 2 "Roots, tubers, and plantains" 3 "Pulses, nuts and seeds" ///
			4 "Vegetables" 5 "Fruits" 6 "Meat" 7 "Fish and seafood" 8 "Milk and dairy products" 9 "Eggs" ///
			10 "Oils and fats" 11 "Sugar and sugary products" 12 "Spices, condiments and beverages"
lab val _Foodgroup foodgroups


* Label variables
lab var _Foodgroup "Food group"
lab var Ncons_shr_purch "Share of food items consumed from purchases (in %)"
lab var ll_Ncons_shr_purch "Lower limit 95% CI (consumption from purchases)"
lab var ul_Ncons_shr_purch "Upper limit 95% CI (consumption from purchases)"
lab var Ncons_shr_own "Share of food items consumed from own production (in %)"
lab var ll_Ncons_shr_own "Lower limit 95% CI (consumption from own production)"
lab var ul_Ncons_shr_own "Upper limit 95% CI (consumption from own production)"
lab var Ncons_shr_rec "Share of food items consumed from gifts/in-kind (in %)"
lab var ll_Ncons_shr_rec "Lower limit 95% CI (consumption from gifts/in-kind)"
lab var ul_Ncons_shr_rec "Upper limit 95% CI (consumption from gifts/in-kind)"

lab var sample_purch "Sample size (consumption from purchases)"
lab var sample_own "Sample size (consumption from own production)"
lab var sample_rec "Sample size (consumption from gifts/in-kind)" 

drop if inlist(_Foodgroup,10,11,12) 

save "$datadir/graphs and tables/byFGitem_global.dta", replace

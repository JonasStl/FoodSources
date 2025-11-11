/*******************************************************************************
Preparation for 
- Fig. S8 | Consumption and sourcing of nine food groups by rural-urban location. 
*******************************************************************************/
use "$datadir/processed_analysis.dta", clear
keep country hhid HDDS_? HDDS_?? HDDS_?_own HDDS_??_own HDDS_?_purch HDDS_??_purch HDDS_?_rec HDDS_??_rec *_purchindep *_purch_only urban wgt stratum psu totpop surveyid w_new

gen insample = (HDDS_1 < . & urban < .) 
bysort surveyid: egen double all_obs = sum(w_new) if w_new != . & insample == 1
gen wgt_new = .
replace wgt_new = w_new*totpop/all_obs

svyset psu [pw = wgt_new], strata(stratum) singleunit(centered)

mat define M = J(24,2,.)

local m = 0
local n = 1
forv v = 1/24 {
	
	mat M[`v',1] = `n'
	mat M[`v',2] = `m'

		if `m' == 1 {
			local m = 0
			local n = `n' + 1
		}
		else {
			local m = `m' + 1
		}
	}
mat colnames M = _Foodgroup urban

* Consumption (Sample: 1057791)
svy, subpop(insample): mean HDDS_? HDDS_?? , over(urban)

mat define A1 = r(table)
mat define B1 = A1'
mat define C1 = J(24,1,e(N))
mat define M1 = B1[1..24,1..2], B1[1..24,5..6], C1
mat colnames M1 = consumption se_consumption ll_consumption ul_consumption sample_consumption

* Purchases
svy, subpop(insample): mean HDDS_?_purch HDDS_??_purch, over(urban)

mat define A2 = r(table)
mat define B2 = A2'
mat define C2 = J(24,1,e(N))
mat define M2 = B2[1..24,1..2], B2[1..24,5..6], C2
mat colnames M2 = purchases se_purch ll_purch ul_purch sample_purch

* Own consumption
svy, subpop(insample): mean HDDS_?_own HDDS_??_own, over(urban)

mat define A3 = r(table)
mat define B3 = A3'
mat define C3 = J(24,1,e(N))
mat define M3 = B3[1..24,1..2], B3[1..24,5..6], C3
mat colnames M3 = owncons se_own ll_own ul_own sample_own

* Gifts/in-kind (Sample: 724466)
svy, subpop(insample): mean HDDS_?_rec HDDS_??_rec, over(urban)

mat define A4 = r(table)
mat define B4 = A4'
mat define C4 = J(24,1,e(N))
mat define M4 = B4[1..24,1..2], B4[1..24,5..6], C4
mat colnames M4 = receivings se_rec ll_rec ul_rec sample_rec

* Only Purchases
svy, subpop(insample): mean HDDS_?_purch_only HDDS_??_purch_only, over(urban)

mat define A5 = r(table)
mat define B5 = A5'
mat define C5 = J(24,1,e(N))
mat define M5 = B5[1..24,1..2], B5[1..24,5..6], C5
mat colnames M5 = purchases_only se_purch_only ll_purch_only ul_purch_only sample_purch_only

	
* Combining
mat X = M, M1, M2, M3, M4, M5

drop _all

svmat X, names(col)

lab define foodgroups 1 "Cereals" 2 "Roots, tubers, and plantains" 3 "Pulses, nuts and seeds" ///
			4 "Vegetables" 5 "Fruits" 6 "Meat" 7 "Fish and seafood" 8 "Milk and dairy products" 9 "Eggs" ///
			10 "Oils and fats" 11 "Sugar and sugary products" 12 "Spices, condiments and beverages"
lab val _Foodgroup foodgroups
lab val urban urban


keep if inrange(_Foodgroup,1,9)


* Label variables
lab var urban "Rural-urban location"
lab var _Foodgroup "Food group"
lab var consumption "Households that consume FG (in %)"
lab var ll_consumption "Lower limit 95% CI (consumption)"
lab var ul_consumption "Upper limit 95% CI (consumption)"
lab var purchases "Households that consume FG from purchases (in %)"
lab var ll_purch "Lower limit 95% CI (consumption from purchases)"
lab var ul_purch "Upper limit 95% CI (consumption from purchases)"
lab var purchases_only "Households that consume FG from only purchases (in %)"
lab var ll_purch_only "Lower limit 95% CI (consumption only from purchases)"
lab var ul_purch_only "Upper limit 95% CI (consumption only from purchases)"
lab var owncons "Households that consume FG from own production (in %)"
lab var ll_own "Lower limit 95% CI (consumption from own production)"
lab var ul_own "Upper limit 95% CI (consumption from own production)"
lab var receivings "Households that consume FG from gifts/in-kind (in %)"
lab var ll_rec "Lower limit 95% CI (consumption from gifts/in-kind)"
lab var ul_rec "Upper limit 95% CI (consumption from gifts/in-kind)"

lab var se_consumption "Standard Error (consumption of FG)"
lab var se_purch_only "Standard Error (consumption of FG only from purchases)"
lab var se_purch "Standard Error (consumption of FG from purchases)"
lab var se_own "Standard Error (consumption of FG from own production)"
lab var se_rec "Standard Error (consumption of FG from gifts/in-kind)"

lab var sample_consumption "Sample size (consumption)"
lab var sample_purch "Sample size (consumption from purchases)"
lab var sample_own "Sample size (consumption from own production)"
lab var sample_rec "Sample size (consumption from gifts/in-kind)" 
lab var sample_purch_only "Sample size (consumption only from purchases)"

drop if inlist(_Foodgroup,10,11,12) 


save "$datadir/graphs and tables/FG_global_urban.dta", replace

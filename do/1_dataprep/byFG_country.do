/*******************************************************************************
Preparation for 
- Extended Data Fig. 1 | Country‐level consumption and sourcing of nine food groups. 
- Fig. S2 | Relationship between food group consumption and proportions from purchases and own consumption. 
*******************************************************************************/
use "$datadir/processed_analysis.dta", clear
keep country hhid HDDS_? HDDS_?_own HDDS_?_purch  HDDS_?_rec  *_purchindep *_purch_only wgt_raw w_new stratum psu totpop year surveyid

egen countryyear = concat(country year), punct(" ")
sencode countryyear, gen(country_enc) 

gen insample = (HDDS_1 < . ) 
bysort surveyid: egen double all_obs = sum(w_new) if w_new != . & insample == 1
gen wgt_new = .
replace wgt_new = w_new*totpop/all_obs

//analysis
svyset psu [pw = wgt_new], strata(stratum) singleunit(centered)

mat define M = J(405,2,.)

local m = 1
local n = 1
forv v = 1/405 {
	
	mat M[`v',1] = `m'
	mat M[`v',2] = `n'

		if `m' == 45 {
			local m = 1
			local n = `n' + 1
		}
		else {
			local m = `m' + 1
		}
}
mat colnames M = country_enc _Foodgroup

* Consumption (sample: 1,107,826)
svy, subpop(insample): mean HDDS_?, over(country_enc)

mat define A1 = r(table)
mat define B1 = A1'
mat define C1 = J(405,1,e(N))
mat define M1 = B1[1..405,1..2], B1[1..405,5..6], C1
mat colnames M1 = consumption se_consumption ll_consumption ul_consumption sample_consumption

* Purchases
svy, subpop(insample): mean HDDS_?_purch, over(country_enc)

mat define A2 = r(table)
mat define B2 = A2'
mat define C2 = J(405,1,e(N))
mat define M2 = B2[1..405,1..2], B2[1..405,5..6], C2
mat colnames M2 = purchases se_purch ll_purch ul_purch sample_purch

* Own consumption
svy, subpop(insample): mean HDDS_?_own, over(country_enc)

mat define A3 = r(table)
mat define B3 = A3'
mat define C3 = J(405,1,e(N))
mat define M3 = B3[1..405,1..2], B3[1..405,5..6], C3
mat colnames M3 = owncons se_own ll_own ul_own sample_own

* Only Purchases
svy, subpop(insample): mean HDDS_?_purch_only, over(country_enc)

mat define A5 = r(table)
mat define B5 = A5'
mat define C5 = J(405,1,e(N))
mat define M5 = B5[1..405,1..2], B5[1..405,5..6], C5
mat colnames M5 = purchases_only se_purch_only ll_purch_only ul_purch_only sample_purch_only

* Gifts/in-kind (need to create empty rows for missing countries) (sample: 774,501)
svy, subpop(insample): mean HDDS_?_rec, over(country_enc)

mat define A4 = r(table)
mat define B4 = A4'
mat define C4 = J(405,1,e(N))

levelsof country_enc if psu != . & HDDS_1_rec != .
local n_cntries = r(r)
local lvls_cntries = "`r(levels)'"
mat define D4 = J(405,4,.)

foreach num of numlist `lvls_cntries' {
		
	forv v = 1/9 {
		
		local row = (`v'-1)*45 + `num'
		
		mat D4[`row',1] = B4["c.HDDS_`v'_rec@`num'.country_enc",1]
		mat D4[`row',2] = B4["c.HDDS_`v'_rec@`num'.country_enc",2]
		mat D4[`row',3] = B4["c.HDDS_`v'_rec@`num'.country_enc",5]
		mat D4[`row',4] = B4["c.HDDS_`v'_rec@`num'.country_enc",6]
	}
}

mat define M4 = D4, C4
mat colnames M4 = receivings se_rec ll_rec ul_rec sample_rec

* Combining
mat X = M, M1, M2, M3, M4, M5


drop _all
svmat X, names(col)


lab define foodgroups 1 "Cereals" 2 "Roots, tubers, and plantains" 3 "Pulses, nuts and seeds" ///
			4 "Vegetables" 5 "Fruits" 6 "Meat" 7 "Fish and seafood" 8 "Milk and dairy products" 9 "Eggs" ///
			10 "Oils and fats" 11 "Sugar and sugary products" 12 "Spices, condiments and beverages"

lab val _Foodgroup foodgroups
lab val country_enc country_enc

//label
lab var country_enc "Country & Year"
lab var _Foodgroup "Food group"
lab var consumption "Households that consume FG (in %)"
lab var ll_consumption "Lower limit 95% CI (consumption)"
lab var ul_consumption "Upper limit 95% CI (consumption)"
lab var se_consumption "Standard Error (consumption)"
lab var purchases "Households that consume FG from purchases (in %)"
lab var ll_purch "Lower limit 95% CI (consumption from purchases)"
lab var ul_purch "Upper limit 95% CI (consumption from purchases)"
lab var se_purch "Standard Error (consumption from purchases)"
lab var purchases_only "Households that consume FG from only purchases (in %)"
lab var ll_purch_only "Lower limit 95% CI (consumption only from purchases)"
lab var ul_purch_only "Upper limit 95% CI (consumption only from purchases)"
lab var se_purch_only "Standard Error (consumption only from purchases)"
lab var owncons "Households that consume FG from own production (in %)"
lab var ll_own "Lower limit 95% CI (consumption from own production)"
lab var ul_own "Upper limit 95% CI (consumption from own production)"
lab var se_own "Standard Error (consumption from own production)"
lab var receivings "Households that consume FG from gifts/in-kind (in %)"
lab var ll_rec "Lower limit 95% CI (consumption from gifts/in-kind)"
lab var ul_rec "Upper limit 95% CI (consumption from gifts/in-kind)"
lab var se_rec "Standard Error (consumption from gifts/in-kind)"
lab var sample_consumption "Sample (consumption)"
lab var sample_purch "Sample (consumption from purchases)"
lab var sample_purch_only "Sample (consumption only from purchases)"
lab var sample_own "Sample (consumption from own production)"
lab var sample_rec "Sample (consumption from gifts/in-kind)"

//percent of consumers
gen purchshr = (purchases/consumption)*100
gen purchonlyshr = (purchases_only/consumption)*100
gen ownshr = (owncons/consumption)*100
gen inkindshr = (receivings/consumption)*100
lab var purchshr "Share of consumers who purchase FG (in %)"
lab var purchonlyshr "Share of consumers who only purchase FG (in %)"
lab var ownshr "Share of consumers who own consume FG (in %)"
lab var inkindshr "Share of consumers who receive FG from gifts/in-kind (in %)"


save "$datadir/graphs and tables/byFG_bycountry.dta", replace






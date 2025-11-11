/*******************************************************************************
Preparation for 
- Fig. 5. | Healthy household dietary diversity score (HDDS) by rural-urban location and household consumption expenditure group. 
*******************************************************************************/
use "$datadir/processed_analysis.dta", clear

gen own_perc = round((DDS_hlthy_own/DDS_hlthy)*100)
replace own_perc = 0 if DDS_hlthy == 0 & DDS_hlthy_own == 0
gen purch_perc = round((DDS_hlthy_purch/DDS_hlthy)*100)
replace purch_perc = 0 if DDS_hlthy == 0 & DDS_hlthy_purch == 0
gen gifts_perc = round((DDS_hlthy_rec/DDS_hlthy)*100)
replace gifts_perc = 0 if DDS_hlthy == 0 & DDS_hlthy_rec == 0

lab var purch_perc "Share of HDDS covered through purchases"
lab var own_perc "Share of HDDS covered through own consumption"
lab var gifts_perc "Share of HDDS covered through gifts/in-kind"

local vars = "DDS_hlthy DDS_hlthy_purch DDS_hlthy_own DDS_hlthy_rec purch_perc own_perc gifts_perc"
local n_vars: word count `vars'

gen insample = (DDS_hlthy < . & psu < . & w_new < . & urban < . & povcat < .) 
bysort surveyid: egen double all_obs = sum(w_new) if w_new != . & insample == 1
gen wgt_new = .
replace wgt_new = w_new*totpop/all_obs

svyset psu [pw = wgt_new], strata(stratum) singleunit(centered)

mat define M = J(8,(`n_vars'*4*2)+2,.) 

* Expenditure group and rural/urban variables
local m = 1
forv v = 1/4 {
	
	forv n = 0/1 {
		
		mat M[`m',1] = `v'
		mat M[`m',2] = `n'
		
		local m = `m' + 1
	}
}

* Rural/Urban Averages
local z = 1
local w = 1
foreach var of local vars {
	
	local `var'_lbl: var label `var'	
	
	svy, subpop(insample): mean `var', over(urban)
	mat define A`w' = r(table)
	mat define B`w' = A`w''

	local m = 1
	forv v = 1/4 {
		
		forv n = 0/1 {
			
			mat M[`m',`z'+2] = B`w'["c.`var'@`n'.urban",1]
			mat M[`m',`z'+3] = B`w'["c.`var'@`n'.urban",2]
			mat M[`m',`z'+4] = B`w'["c.`var'@`n'.urban",5]
			mat M[`m',`z'+5] = B`w'["c.`var'@`n'.urban",6]
			
			local m = `m' + 1
		}
		
	}
	
	local colnames1 = "`colnames1' loc_`var' loc_se_`var' loc_ll_`var' loc_ul_`var'"
	
	local z = `z' + 4
	local w = `w' + 1
}


* Averages by Income group and rural/urban
local z = 1
local w = 1
foreach var of local vars {
	
	svy, subpop(insample): mean `var', over(povcat urban)
	/* Sample sizes: 
	- Dietary diversity, purchases, own consumption: 1,037,972 for (pop. size: 2,803,363,500)
	- Gifts/in-kind: 704,647  (pop. size: 2,490,927,058)
	*/
	mat define A`w' = r(table)
	mat define B`w' = A`w''

	local m = 1
	forv v = 1/4 {
		
		forv n = 0/1 {
			
			mat M[`m',`n_vars'*4+2+`z'] = B`w'["c.`var'@`v'.povcat#`n'.urban",1]
			mat M[`m',`n_vars'*4+3+`z'] = B`w'["c.`var'@`v'.povcat#`n'.urban",2]
			mat M[`m',`n_vars'*4+4+`z'] = B`w'["c.`var'@`v'.povcat#`n'.urban",5]
			mat M[`m',`n_vars'*4+5+`z'] = B`w'["c.`var'@`v'.povcat#`n'.urban",6]
			
			local m = `m' + 1
			
		}
		
	}
	
	local colnames2 = "`colnames2' `var' se_`var' ll_`var' ul_`var'"
	
	local z = `z' + 4
	local w = `w' + 1
}


drop _all
mat colnames M = povcat urban `colnames1' `colnames2'
svmat M, names(col)

lab val povcat pov
lab val urban urban


gen purchperc = string(purch_perc, "%9.0f") + "%"
gen ownperc = string(own_perc, "%9.0f") + "%"
gen giftsperc = string(gifts_perc, "%9.0f") + "%"

gen loc_purch_perc_dec = string(loc_purch_perc, "%9.0f") + "%"
gen loc_own_perc_dec = string(loc_own_perc, "%9.0f") + "%"
gen loc_gifts_perc_dec = string(loc_gifts_perc, "%9.0f") + "%"

//labelling
lab var povcat "Poverty groups"
lab var povcat "Rural/Urban Location"

foreach var of local vars {
	
	lab var `var' "``var'_lbl'"
	lab var se_`var' "Standard Error: ``var'_lbl'"
	lab var ll_`var' "Lower Limit 95% CI: ``var'_lbl'"
	lab var ul_`var' "Upper Limit 95% CI: ``var'_lbl'"
	
	lab var loc_`var' "Location average: ``var'_lbl'"
	lab var loc_se_`var' "Location average: SE: ``var'_lbl'"
	lab var loc_ll_`var' "Location average: LL 95% CI: ``var'_lbl'"
	lab var loc_ul_`var' "Location average: UL 95% CI: ``var'_lbl'"
	
}


save "$datadir/graphs and tables/DD_global_rururb_hhinc.dta", replace


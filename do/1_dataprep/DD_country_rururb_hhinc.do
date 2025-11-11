/*******************************************************************************
Preparation for 
- Extended Data Fig. 4 | Rural–urban and poverty gradients in HDDS and sourcing. 
- Fig. S19 | Differences in healthy HDDS and sourcing across location–income groups. 
*******************************************************************************/
use "$datadir/processed_analysis.dta", clear

egen countryyear = concat(country year), punct(" ")
encode countryyear, gen(country_enc)


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
local vars_n: word count `vars'
keep country country_enc hhid stratum psu `vars' totpop surveyid w_new urban exp_pc_terc

gen insample = (DDS_hlthy < . & exp_pc_terc < . & urban < .) 
bysort surveyid: egen double all_obs = sum(w_new) if w_new != . & insample == 1
gen wgt_new = .
replace wgt_new = w_new*totpop/all_obs

svyset psu [pw = wgt_new], strata(stratum) singleunit(centered)

levelsof country_enc, local(lvls_cntries)
local n_cntries = r(r)

mat define M = J(`n_cntries'*2*3,(`vars_n'*4)+3,.)

local m = 1
foreach num of numlist `lvls_cntries' {
	
	forv v = 1/3 {
	
		forv n = 0/1 {
			
			mat M[`m',1] = `num'
			mat M[`m',2] = `v'
			mat M[`m',3] = `n'
			
			local m = `m' + 1
		}
	}
}


* Averages by Income group and rural/urban
local z = 1
local w = 1
foreach var of local vars {
	
	local `var'_lbl: var label `var'	
	
	svy, subpop(insample): mean `var', over(country_enc exp_pc_terc urban)
	mat define A`w' = r(table)
	mat define B`w' = A`w''
	
	levelsof country_enc if psu != . & `var' != . & insample == 1, local(lvls_cntries_`var')
	local n_cntries_`var' = r(r)
	
	foreach num of numlist `lvls_cntries_`var'' {
		
		local m = 0
		
		forv v = 1/3 {
			
			forv n = 0/1 {
				
				mat M[`num'*2*3-5+`m',`z'+3] = B`w'["c.`var'@`num'.country_enc#`v'.exp_pc_terc#`n'.urban",1]
				mat M[`num'*2*3-5+`m',`z'+4] = B`w'["c.`var'@`num'.country_enc#`v'.exp_pc_terc#`n'.urban",2]
				mat M[`num'*2*3-5+`m',`z'+5] = B`w'["c.`var'@`num'.country_enc#`v'.exp_pc_terc#`n'.urban",5]
				mat M[`num'*2*3-5+`m',`z'+6] = B`w'["c.`var'@`num'.country_enc#`v'.exp_pc_terc#`n'.urban",6]
				
				local m = `m' + 1
				
			}
		}
	}
	
	local colnames = "`colnames' `var' se_`var' ll_`var' ul_`var'"
	
	local z = `z' + 4
	local w = `w' + 1
}

levelsof country_enc if insample == 1, local(lvls_cntries) 

drop _all
mat colnames M = country_enc exp_pc_terc urban `colnames'
svmat M, names(col)

lab val country_enc country_enc
decode country_enc, gen(country)
lab val urban urban


* Only keep countries with location and expenditure information
local lvls_csv : subinstr local lvls_cntries " " ",", all
keep if inlist(country_enc, `lvls_csv')

//labelling
foreach var of local vars {
	
	lab var `var' "``var'_lbl'"
	lab var se_`var' "Standard Error: ``var'_lbl'"
	lab var ll_`var' "Lower Limit 95% CI: ``var'_lbl'"
	lab var ul_`var' "Upper Limit 95% CI: ``var'_lbl'"
	
}

lab var country_enc "Country & Year"
lab var country "Country & Year"
lab var exp_pc_terc "Expenditure Tercile"
lab var urban "Rural/Urban Location"

* Sample gifts/in-kind: 704,677
* Sample other: 1,038,002

save "$datadir/graphs and tables/DD_country_rururb_hhinc.dta", replace

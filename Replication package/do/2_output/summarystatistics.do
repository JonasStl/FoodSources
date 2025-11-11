/*******************************************************************************
Replication File for
- Table S4 | Summary Statistics.
*******************************************************************************/
use "${datadir}/graphs and tables/cntrylvldata.dta", clear
drop onlypurch purchindep 


* Table S4
format urban exp_pc_day occup_agr_any anyown %12.2fc
 
export excel country hhsize adulteq sex_hhh urban exp_pc_day occup_agr_any anypurch anyown anyrec using "${workdir}/tables/countrytable.xlsx", replace sheet("Summary Statistics") firstrow(varlabels) keepcellfmt nolabel missing("NA")

* Format with putexcel 
putexcel set "${workdir}/tables/countrytable.xlsx", sheet("Summary Statistics") modify

local last = _N + 1
putexcel A1=("Country ID") ///
		 B1=("(1) Household Size") ///
		 C1=("(2) Adult-Equivalence") ///
		 D1=("(3) Male Household Heads (in %)") ///
         E1=("(4) Urban Population (in %)") ///
         F1=("(5) Per Capita Consumption Expenditure (in 2021 PPPs)") ///
         G1=("(6) Engaged in Agricultural Activities (in %)") ///
         H1=("(7) Any Purchases (in %)") ///
         I1=("(8) Any Own Consumption (in %)") ///
         J1=("(9) Any Gifts/in-kind (in %)")
putexcel A1:K`last', font("Helvetica", 7) // 
putexcel B2:K`last', nformat("#,##0.00")   // Population
putexcel A1:K1, bold // * Bold header

putexcel save




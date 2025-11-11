/*******************************************************************************
Replication File for
- Table 1 | Consumption of foods from purchases and own production by country.
*******************************************************************************/
use "${datadir}/graphs and tables/table1.dta", clear

export excel country onlypurch se_onlypurch anyown se_anyown using "${workdir}/tables/table1.xlsx", replace sheet("Table 1") cell(A3) keepcellfmt nolabel missing("NA")

* Format with putexcel 
putexcel set "${workdir}/tables/table1.xlsx", sheet("Table 1") modify

local last = _N + 2
putexcel A1=("Country & Year") ///
		 B2=("Mean") ///
		 C2=("SD") ///
		 D2=("Mean") ///
		 E2=("SD")
putexcel B1:C1=("Only Purchases") ///
		 D1:E1=("Any Own Consumption"), merge 
putexcel A1:E`last', font("Helvetica", 7)
putexcel B2:E`last', nformat("#,##0.00") 
putexcel A1:E1, bold // * Bold header

putexcel save


* Generate finished variables
gen strL onlypurch_str = string(onlypurch, "%3.2f")
gen strL anyown_str = string(anyown, "%3.2f")
gen strL se_onlypurch_str = string(se_onlypurch, "%3.2f")
gen strL se_anyown_str = string(se_anyown, "%3.2f")

gen purchvar = onlypurch_str + " (" + se_onlypurch_str + ")"
gen ownvar = anyown_str + " (" + se_anyown_str + ")"
export excel country purchvar ownvar using "${workdir}/tables/table1.xlsx", replace sheet("Table 1") cell(A3) keepcellfmt nolabel missing("NA")

local last = _N + 2
putexcel A1=("Country & Year") ///
		 B1=("Only Purchases") ///
		 B2=("Mean (SD)") ///
		 C1=("Any Own Consumption") ///
		 C2=("Mean (SD)") 
putexcel A1:C`last', font("Helvetica", 7)
putexcel B2:C`last', nformat("#,##0.00")  
putexcel A1:C1, bold // * Bold header

putexcel save

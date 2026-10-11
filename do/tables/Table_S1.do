/*******************************************************************************
Replication file for
- Table S1 | Data information.
*******************************************************************************/

*** Table S1
use "${datadir}/graphs and tables/tableS3.dta", clear

replace totpop = totpop/1000

format totpop %12.0fc
format samplesize   %12.0fc

order country countrycode survey_name strtyear endyear totpop samplesize

export excel using "${workdir}/tables/Table_S1.xlsx", replace firstrow(variables) keepcellfmt

* Format with putexcel 
putexcel set "${workdir}/tables/Table_S1.xlsx", modify

local last = _N + 1
putexcel A1=("Country Name") ///
         B1=("ISO3-Code") ///
         C1=("Survey Name") ///
         D1=("Start Year") ///
         E1=("End Year") ///
         F1=("Population (in 1,000)") ///
         G1=("Sample Size")
putexcel A1:G`last', font("Helvetica", 7) // 
putexcel A1:G1, bold // * Bold header
putexcel F2:F`last', nformat("#,##0")   // Population
putexcel G2:G`last', nformat("#,##0")   // Sample Size

putexcel save



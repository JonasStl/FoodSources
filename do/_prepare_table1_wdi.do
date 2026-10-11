/*******************************************************************************
Shared data preparation for Figure 1a and Figure S2.
*******************************************************************************/

use "${datadir}/graphs and tables/table1.dta", clear

gen int year = real(substr(strtrim(country), -4, 4))
gen str80 countryname = strtrim( ///
    substr(strtrim(country), 1, strlen(strtrim(country)) - 4) ///
)

kountry countryname, from(other) stuck marker
rename _ISO3N_ iso3n
kountry iso3n, from(iso3n) to(iso3c)
rename _ISO3C_ isocode

drop iso3n MARKER
replace isocode = "COD" if countryname == "Dem. Rep. of the Congo"
replace isocode = "COK" if countryname == "Cook Island"
replace isocode = "TKL" if countryname == "Tokelau"

merge 1:1 isocode year using "${datadir}/wbdata.dta", nogen keep(match master)
replace incomelevelname = "Low income" if isocode == "ETH"

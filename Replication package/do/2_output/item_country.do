/*******************************************************************************
Replication File for
- Fig. S14 | Food item sources by country. 
*******************************************************************************/

use "${datadir}/graphs and tables/items_country.dta", clear

* Fig. S14:
graph set window fontface "Helvetica"
twoway rcap ll_Ncons_rec_shr ul_Ncons_rec_shr _country, lcolor(gold) horizontal lwidth(vthin) || ///
	rcap ll_Ncons_own_shr ul_Ncons_own_shr _country, lcolor(sienna) horizontal lwidth(vthin) || ///
	rcap ll_Ncons_purch_shr ul_Ncons_purch_shr _country, lcolor(midblue) horizontal lwidth(vthin) || ///
	scatter _country Ncons_rec_shr if !inlist(country,"Argentina 2017","Barbados 2016","Colombia 2016","Dominican Republic 2018","Suriname 2016","Liberia 2016","Jamaica 2019"), msymbol(o) mcolor(gold) msize(small) || ///
	scatter _country ll_Ncons_rec_shr if !inlist(country,"Argentina 2017","Barbados 2016","Colombia 2016","Dominican Republic 2018","Suriname 2016","Liberia 2016","Jamaica 2019"), msymbol(i) mlabel(recperc) mlabposition(9) mlabcolor(gold) mlabsize(5pt) mlabgap(0pt) || ///
	scatter _country Ncons_rec_shr if inlist(country,"Argentina 2017","Barbados 2016","Colombia 2016","Dominican Republic 2018","Suriname 2016","Liberia 2016","Jamaica 2019"), msymbol(o) mcolor(gold) msize(small) || ///
	scatter _country ul_Ncons_rec_shr if inlist(country,"Argentina 2017","Barbados 2016","Colombia 2016","Dominican Republic 2018","Suriname 2016","Liberia 2016","Jamaica 2019"), msymbol(i) mlabel(recperc) mlabposition(3) mlabcolor(gold) mlabsize(5pt) mlabgap(0pt) || ///
	scatter _country Ncons_own_shr if !inlist(country,"Argentina 2017","Barbados 2016","Colombia 2016","Dominican Republic 2018","Suriname 2016","Liberia 2016","Bhutan 2012","Jamaica 2019"), msymbol(o) mcolor(sienna) msize(small) || ///
	scatter _country ul_Ncons_own_shr if !inlist(country,"Argentina 2017","Barbados 2016","Colombia 2016","Dominican Republic 2018","Suriname 2016","Liberia 2016","Bhutan 2012","Jamaica 2019"), msymbol(i) mlabel(ownperc) mlabposition(3) mlabcolor(sienna) mlabsize(5pt)  mlabgap(0.5pt) || ///
	scatter _country Ncons_own_shr if inlist(country,"Argentina 2017","Barbados 2016","Colombia 2016","Dominican Republic 2018","Suriname 2016","Liberia 2016","Bhutan 2012","Jamaica 2019"), msymbol(o) mcolor(sienna) msize(small) || ///
	scatter _country ll_Ncons_own_shr if inlist(country,"Argentina 2017","Barbados 2016","Colombia 2016","Dominican Republic 2018","Suriname 2016","Liberia 2016","Bhutan 2012","Jamaica 2019"), msymbol(i) mlabel(ownperc) mlabposition(9) mlabcolor(sienna) mlabsize(5pt)  mlabgap(0.5pt) || ///
	scatter _country Ncons_purch_shr if !inlist(country,"Bhutan 2012"), msymbol(d) mcolor(midblue) msize(small) || ///
	scatter _country ll_Ncons_purch_shr if !inlist(country,"Bhutan 2012"), msymbol(i) mlabel(purchperc) mlabposition(9) mlabcolor(midblue*1.5) mlabsize(5pt)  mlabgap(1pt) || ///
	scatter _country Ncons_purch_shr if inlist(country,"Bhutan 2012"), msymbol(d) mcolor(midblue) msize(small) || ///
	scatter _country ul_Ncons_purch_shr if inlist(country,"Bhutan 2012"), msymbol(i) mlabel(purchperc) mlabposition(3) mlabcolor(midblue*1.5) mlabsize(5pt)  mlabgap(1pt) || ///
	, xsize(18cm) ysize(21cm) ylabel(1(1)42,valuelabel angle(0) labsize(7pt) nogrid) xlabel(, labsize(7pt)) plotregion(margin(l+2)) graphregion(margin(l+20) color(white)) ///
	legend(region(lstyle(none)) size(7pt) rows(1) position(7) placement(8)  symysize(3)  symxsize(2) ///
	order(4 "Share from gifts/in-kind" 8 "Share from own consumption" 12 "Share from purchases")) ///
	xline(80, lcolor(gs15)) xline(60, lcolor(gs15)) xline(40, lcolor(gs15)) xline(20, lcolor(gs15)) ///
	ytitle("") xtitle("Items consumed from each source (in %)", size(7pt))
graph export "${workdir}/graphs/items_country.png", replace
graph export "${workdir}/graphs/items_country.pdf", replace

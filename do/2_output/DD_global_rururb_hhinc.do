/*******************************************************************************
Replication File for
- Fig. 5. | Healthy household dietary diversity score (HDDS) by rural-urban location and household consumption expenditure group. 
*******************************************************************************/

use "${datadir}/graphs and tables/DD_global_rururb_hhinc.dta", clear

gen zero = 0
decode urban, gen(urban_dec)
decode povcat, gen(povcat_dec)
replace povcat_dec = subinstr(povcat_dec,"USD (2021 PPPs)","",.)

gsort urban povcat
gen order = _n
labmask order, values(povcat_dec)

gen dd_xaxis = 7

graph set window fontface "Helvetica"
twoway rarea loc_ll_DDS_hlthy_rec loc_ul_DDS_hlthy_rec order if urban == 0, horizontal color(gold*0.2) || ///
	rarea loc_ll_DDS_hlthy_rec loc_ul_DDS_hlthy_rec order if urban == 1, horizontal color(gold*0.2) || ///
	rarea loc_ll_DDS_hlthy_purch loc_ul_DDS_hlthy_purch order if urban == 0, horizontal color(midblue*0.2) || ///
	rarea loc_ll_DDS_hlthy_purch loc_ul_DDS_hlthy_purch order if urban == 1, horizontal color(midblue*0.2) || ///
	rarea loc_ll_DDS_hlthy_own loc_ul_DDS_hlthy_own order if urban == 0, horizontal color(sienna*0.2) || ///
	rarea loc_ll_DDS_hlthy_own loc_ul_DDS_hlthy_own order if urban == 1, horizontal color(sienna*0.2) || ///
	rarea loc_ll_DDS_hlthy loc_ul_DDS_hlthy order if urban == 0, horizontal color(midgreen*0.2) || ///
	rarea loc_ll_DDS_hlthy loc_ul_DDS_hlthy order if urban == 1, horizontal color(midgreen*0.2) || ///
	line  order loc_DDS_hlthy_rec if urban == 0, lcolor(gold*0.7) lpattern(dash) || ///
	line  order loc_DDS_hlthy_rec if urban == 1, lcolor(gold*0.7) lpattern(dash) || ///
	line  order loc_DDS_hlthy_purch if urban == 0, lcolor(midblue*0.7) lpattern(dash) || ///
	line  order loc_DDS_hlthy_purch if urban == 1, lcolor(midblue*0.7) lpattern(dash) || ///
	line  order loc_DDS_hlthy_own if urban == 0, lcolor(sienna*0.7) lpattern(dash) || ///
	line  order loc_DDS_hlthy_own if urban == 1, lcolor(sienna*0.7) lpattern(dash) || ///
	line  order loc_DDS_hlthy if urban == 0, lcolor(midgreen*0.7) lpattern(dash) || ///
	line  order loc_DDS_hlthy if urban == 1, lcolor(midgreen*0.7) lpattern(dash) || ///
	rbar zero DDS_hlthy_purch order , horizontal barw(0.7) color(midblue*0.5) || ///
	rbar DDS_hlthy_purch DDS_hlthy order, horizontal barw(0.7) color(midgreen*0.5)  || ///
	rcap ll_DDS_hlthy_rec ul_DDS_hlthy_rec order, lcolor(gold) horizontal lwidth(medium) || ///
	rcap ll_DDS_hlthy_own ul_DDS_hlthy_own order, lcolor(sienna) horizontal lwidth(medium) || ///
	rcap ll_DDS_hlthy_purch ul_DDS_hlthy_purch order, lcolor(midblue*1.5) horizontal lwidth(medium) || ///
	rcap ll_DDS_hlthy ul_DDS_hlthy order, lcolor(midgreen*1.5) horizontal lwidth(medium) || /// 
	scatter order DDS_hlthy_rec, mcolor(gold) msize(medium) msymbol(o) || ///
	scatter order DDS_hlthy_own, mcolor(sienna) msize(medium) msymbol(o) || ///
	scatter order DDS_hlthy_own if !inlist(order,7,8), msymbol(i) mlabel(ownperc) mlabposition(3) mlabformat(%9.0f) mlabcolor(sienna) mlabsize(6pt)  mlabgap(3pt) || ///
	scatter order DDS_hlthy_own if inlist(order,7,8), msymbol(i) mlabel(ownperc) mlabposition(3) mlabformat(%9.0f) mlabcolor(sienna) mlabsize(6pt)  mlabgap(5pt) || ///
	scatter order ll_DDS_hlthy_purch, msymbol(i) mlabel(purchperc) mlabposition(9) mlabformat(%9.0f) mlabcolor(midblue*1.5) mlabsize(6pt)  mlabgap(0pt) || ///
	scatter order loc_DDS_hlthy_purch if inlist(order,1), msymbol(i) mlabel(loc_purch_perc_dec) mlabposition(12) mlabformat(%9.1f) mlabcolor(midblue*0.7) mlabsize(6pt) mlabgap(4pt) || ///
	scatter order loc_DDS_hlthy_purch if inlist(order,8), msymbol(i) mlabel(loc_purch_perc_dec) mlabposition(6) mlabformat(%9.1f) mlabcolor(midblue*0.7) mlabsize(6pt) mlabgap(4pt) || ///
	scatter order loc_DDS_hlthy_own if inlist(order,1), msymbol(i) mlabel(loc_own_perc_dec) mlabposition(12) mlabformat(%9.1f) mlabcolor(sienna*0.7) mlabsize(6pt)  mlabgap(4pt) || ///
	scatter order loc_DDS_hlthy_own if inlist(order,8), msymbol(i) mlabel(loc_own_perc_dec) mlabposition(6) mlabformat(%9.1f) mlabcolor(sienna*0.7) mlabsize(6pt)  mlabgap(4pt) || ///
	scatter order dd_xaxis, msymbol(i) mlabel(DDS_hlthy) mlabposition(3) mlabformat(%9.1f) mlabcolor(midgreen) mlabsize(7pt) mlabgap(1pt) || ///
	,  graphregion(margin(l+5) color(white)) xsize(18.0cm) ysize(5.0cm) yscale(reverse)  ylabel(1(1)8,valuelabel angle(0) labsize(6pt) nogrid) xlabel(, labsize(7pt)) ///
	legend(region(lstyle(none)) size(7pt) rows(1) position(7) /*bmargin(l-38 r-3)*/ bexpand placement(8) symysize(6)  symxsize(9) ///
	order(17 "HDDS from purchases" "{it:(number is % from tot. HDDS)}" 18 "HDDS not" "purchased" 24 "HDDS from own consumption" "{it:(number is % from tot. HDDS)}" 23 "HDDS from" "gifts/in-kind")) ///
	xline(8, lcolor(gs15)) xline(7, lcolor(gs15)) xline(6, lcolor(gs15)) xline(5, lcolor(gs15)) xline(4, lcolor(gs15)) xline(3, lcolor(gs15)) xline(2, lcolor(gs15)) xline(1, lcolor(gs15)) ///
	yline(4.5 , lpattern(dash) lcolor(black)) ///
	ytitle("{bf: Urban} by        {bf:Rural} by" "income group     income group", size(7pt)) xtitle("Healthy HDDS (0-9)", size(7pt)) ///
	plotregion(margin(l+1 r+1 b+5 t+1)) subtitle(,bcolor(gs15) size(7pt))
	
	
graph export "${workdir}/graphs/DD_global_rururb_hhinc2.png", replace
graph export "${workdir}/graphs/DD_global_rururb_hhinc2.pdf", replace





/*******************************************************************************
Replication File for
- Fig. S15 | Development of healthy dietary diversity and sources over time. 
*******************************************************************************/
use "${datadir}/graphs and tables/timetrends.dta", clear

* Fig. S15 
graph set window fontface "Helvetica"
sort country year
twoway 	area DDS_hlthy DDS_hlthy_purch year, lcolor(midgreen midblue) fcolor(midgreen*0.4 midblue*0.4) || ///
		line DDS_hlthy_rec year, lcolor(gold) || ///
		line DDS_hlthy_own year, lcolor(sienna) || ///
		scatter DDS_hlthy_own year, msymbol(i) mlabel(ownperc) mlabposition(12) mlabgap(0pt) mlabsize(6pt) mlabcolor(black) || ///
		scatter DDS_hlthy_purch year, msymbol(i) mlabel(purchperc) mlabposition(6) mlabgap(0pt) mlabsize(6pt) mlabcolor(black) || ///
		, by(country, cols(2) imargin(vsmall) graphregion(color(white)) note("")) ///
		subtitle(,bcolor(gs15) size(10pt)) ///
		legend(region(lstyle(none)) rows(1) size(7pt) symxsize(3) symysize(2) order(1 "HDDS not purchased" 2 "HDDS purchased" 4 "HDDS from own" "consumption" 3 "HDDS from" "gifts/in-kind")) ///
		yscale(range(0 8)) ylabel(0(1)8, angle(0) labsize(9pt)) ///
		xscale(range(2004 2023)) xlabel(2004(2)2023, labsize(9pt) valuelabel) ///
		ytitle("Healthy HDDS (0-9)", size(10pt)) ///
		xtitle("Year", size(10pt)) ///
		xlab(, labsize(7pt)) ///
		xsize(18.5cm) ysize(21.5cm) ///
		graphregion(color(white))
		
graph export "${workdir}/graphs/DD_overtime.png", replace
graph export "${workdir}/graphs/DD_overtime.pdf", replace

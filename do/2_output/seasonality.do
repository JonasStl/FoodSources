/*******************************************************************************
Replication File for
- Fig. S16 | Monthly household dietary diversity score (HDDS) and sourcing in eleven countries. 
- Fig. S17 | Food item sourcing by month in eleven countries. 
- Fig. S18 | Seasonality in household consumption of selected food groups by source. 
*******************************************************************************/
use "${datadir}/graphs and tables/seasonality.dta", clear

* Create labels
gen purchperc = string(round(purch_perc)) + "%"
gen ownperc = string(round(own_perc)) + "%"
gen giftsperc = string(round(gifts_perc)) + "%"
lab var purchperc "Share of HDDS covered through purchases"
lab var ownperc "Share of HDDS covered through own consumption"
lab var giftsperc "Share of HDDS covered through gifts/in-kind"

gen Ncons_purch_shr_lbl = string(round(Ncons_purch_shr)) + "%"
gen Ncons_own_shr_lbl = string(round(Ncons_own_shr)) + "%"
gen Ncons_rec_shr_lbl = string(round(Ncons_rec_shr)) + "%"
lab var Ncons_purch_shr_lbl "Proportion of food items consumed from purchases"
lab var Ncons_own_shr_lbl "Proportion of food items consumed from own production"
lab var Ncons_rec_shr_lbl "Proportion of food items consumed from gifts/in-kind"

* Replace long names with first 3 letters
label define shortmonth 1 "Jan" 2 "Feb" 3 "Mar" 4 "Apr" 5 "May" 6 "Jun" ///
                        7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec", modify

* Apply the new shorter labels
label values month shortmonth

* Fig. S16:
graph set window fontface "Helvetica"
twoway 	area DDS_hlthy DDS_hlthy_purch month, lcolor(midgreen midblue) fcolor(midgreen*0.4 midblue*0.4) || ///
		line DDS_hlthy_rec month, lcolor(gold) || ///
		line DDS_hlthy_own month, lcolor(sienna) || ///
		scatter DDS_hlthy_own month, msymbol(i) mlabel(ownperc) mlabposition(1) mlabgap(1pt) mlabsize(7pt) mlabcolor(black) || ///
		scatter DDS_hlthy_purch month, msymbol(i) mlabel(purchperc) mlabposition(5) mlabgap(1pt) mlabsize(7pt) mlabcolor(black) || ///
		, by(country, cols(2) imargin(tiny) graphregion(color(white)) note("") legend(at(12) ring(0))) ///
		subtitle(,bcolor(gs15) size(10pt)) ///
		legend(region(lstyle(none)) cols(1) size(12pt) symxsize(4) symysize(2) order(2 "HDDS purchased" 1 "HDDS not purchased" 4 "HDDS from own consumption" 3 "HDDS from gifts/in-kind")) ///
		yscale(range(0 8)) ylabel(0(1)8, angle(0) labsize(8pt)) ///
		xscale(range(1 12)) xlabel(1(2)12,  labsize(8pt) valuelabel) ///
		ytitle("Healthy HDDS (0-9)", size(9pt)) ///
		xtitle("Month", size(9pt)) ///
		xlab(, labsize(7pt)) ///
		xsize(18.0cm) ysize(21.5cm) ///
		graphregion(color(white))
		
graph export "${workdir}/graphs/seasonality.png", replace
graph export "${workdir}/graphs/seasonality.pdf", replace

*** Fig. S17: Food item seasonality
graph set window fontface "Helvetica"

twoway (line Ncons_purch_shr month, lcolor(midblue) ) ///
	(scatter Ncons_purch_shr month, msymbol(i) mlabel(Ncons_purch_shr_lbl) mlabcolor(midblue) mlabposition(6) mlabsize(7pt)) ///
	(line Ncons_own_shr month, lcolor(sienna) ) ///
	(scatter Ncons_own_shr month if inlist(country,"Colombia","Dominican Republic","Liberia","Suriname"), msymbol(i) mlabel(Ncons_own_shr_lbl) mlabcolor(sienna) mlabposition(6) mlabsize(7pt)) ///
	(scatter Ncons_own_shr month if !inlist(country,"Colombia","Dominican Republic","Liberia","Suriname"), msymbol(i) mlabel(Ncons_own_shr_lbl) mlabcolor(sienna) mlabposition(12) mlabsize(7pt)) ///
	(line Ncons_rec_shr month, lcolor(gold) ) ///
	(scatter Ncons_rec_shr month if !inlist(country,"Colombia","Dominican Republic","Liberia","Suriname"), msymbol(i) mlabel(Ncons_rec_shr_lbl) mlabcolor(gold) mlabposition(6) mlabsize(7pt)) ///
	(scatter Ncons_rec_shr month if inlist(country,"Colombia","Dominican Republic","Liberia","Suriname"), msymbol(i) mlabel(Ncons_rec_shr_lbl) mlabcolor(gold) mlabposition(12) mlabsize(7pt)) ///
	, by(country, cols(2) graphregion(color(white)) note("") legend(at(12) ring(0))) ///
	subtitle(,bcolor(gs15) size(10pt)) graphregion(color(white)) ///
	xsize(18.0cm) ysize(21.5cm) xscale(range(1 12)) xlab(1(2)12, valuelabel labsize(8pt)) ylab(0(20)100,angle(0) labsize(8pt)) ///
	xtitle("Month", size(9pt)) ytitle("Proportion of consumed items (in %)", size(9pt)) ///
	legend(region(lstyle(none)) size(12pt) cols(1) order(1 "From purchases" 3 "From own production" 6 "From gifts/in-kind"))
	
graph export "${workdir}/graphs/seasonality_items.png", replace
graph export "${workdir}/graphs/seasonality_items.pdf", replace


*** Fig. S18: Food groups
graph set window fontface "Helvetica"
twoway ///
	(connect HDDS_4_purch month, msymbol(s) color(midblue%70) msize(medsmall) lpattern(solid)) ///
	(connect HDDS_5_purch month, msymbol(t) color(midblue%70) msize(medsmall) lpattern(dash)) ///
	(connect HDDS_6789_purch month, msymbol(X) color(midblue%70) msize(medsmall) lpattern(dot)) ///
	(connect HDDS_4_own month, msymbol(s) color(sienna%70) msize(medsmall) lpattern(solid)) ///
	(connect HDDS_5_own month, msymbol(t) color(sienna%70) msize(medsmall) lpattern(dash)) ///
	(connect HDDS_6789_own month, msymbol(X) color(sienna%70) msize(medsmall) lpattern(dot)) ///
	, by(country, cols(2) imargin(tiny) graphregion(color(white)) note("") legend(at(12) ring(0))) ///
	subtitle(,bcolor(gs15) size(10pt)) xsize(18.5cm) ysize(21.5cm) xscale(range(1 12)) xlab(1(2)12, labsize(8pt) valuelabel) ylab(0(20)100, labsize(8pt) angle(0)) ///
	xtitle("Month", size(9pt)) ytitle("Proportion of households (in %)", size(9pt)) graphregion(color(white)) ///
	legend(region(lstyle(none)) size(12pt) rows(3) colfirst order(1 "Vegetables" "(purchases)" 2 "Fruits" "(purchases)" 3 "Animal-source foods" "(purchases)" 4 "Vegetables" "(own consumption)" 5 "Fruits" "(own consumption)" 6 "Animal-source foods" "(own consumption)"))
	
graph export "${workdir}/graphs/seasonality_foodgroups.png", replace
graph export "${workdir}/graphs/seasonality_foodgroups.pdf", replace


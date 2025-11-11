/*******************************************************************************
Replication File for 
- Fig. 1 | Consumption and sourcing of nine food groups. 
*******************************************************************************/
use "${datadir}/graphs and tables/byFG_global.dta", clear

//percent of consumers
gen purch_perc = string(round(purchshr)) + "%"
gen purchonly_perc = string(round(purchonlyshr)) + "%"
gen own_perc = string(round(ownshr)) + "%"
gen rec_perc = string(round(inkindshr)) + "%"
lab var purch_perc "Share of consumers who purchase FG (in %)"
lab var purchonly_perc "Share of consumers who only purchase FG (in %)"
lab var own_perc "Share of consumers who own consume FG (in %)"
lab var rec_perc "Share of consumers who receive FG from gifts/in-kind (in %)"

* Resort food groups based on proportion of consumption from own production
decode _Foodgroup, gen(_Foodgroup_str)
drop _Foodgroup
sencode _Foodgroup_str, gen(_Foodgroup) gsort(owncons)
drop _Foodgroup_str

* Fig. 1
gen zero = 0

graph set window fontface "Helvetica"
twoway ///
	(rbar zero  purchases _Foodgroup, horizontal barw(0.55) bfcolor(midblue*0.6) lcolor(midblue)) ///
	(rbar purchases consumption _Foodgroup, horizontal barw(0.55) bfcolor(midgreen*0.6) lcolor(midgreen)) ///
	(rcap ll_consumption ul_consumption _Foodgroup, horizontal lcolor(midgreen*1.0) lwidth(thin)) ///
	(rcap ll_rec ul_rec _Foodgroup, horizontal lcolor(gold*1.0) lwidth(thin))  || ///
	(rcap ll_own ul_own _Foodgroup, horizontal lcolor(sienna*1.0) lwidth(thin))  || ///
	(rcap ll_purch_only ul_purch_only _Foodgroup, horizontal lcolor(midblue*1.0) lwidth(thin))  || ///
	(rcap ll_purch ul_purch _Foodgroup, horizontal lcolor(midblue*1.0) lwidth(thin))  || ///
	(scatter _Foodgroup purchases, msymbol(i) mlab(purch_perc) mlabposition(12) mlabcolor(midblue) mlabgap(3pt) mlabsize(5pt)) ///
	(scatter _Foodgroup purchases_only, mcolor(midblue*1.1) msize(medsmall) msymbol(D) mlab(purchonly_perc) mlabposition(9) mlabcolor(midblue) mlcolor(black) mlwidth(vthin) mlabgap(1pt) mlabsize(5pt)) ///
	(scatter _Foodgroup receivings, mcolor(gold) msize(medsmall) msymbol(O) mlab(rec_perc) mlabposition(12) mlabcolor(gold) mlcolor(black) mlwidth(vthin) mlabgap(4pt) mlabsize(5pt)) ///
	(scatter _Foodgroup owncons if _Foodgroup != 9, mcolor(sienna) msize(medsmall) msymbol(O) mlab(own_perc) mlabposition(3) mlabcolor(sienna) mlcolor(black) mlwidth(vthin) mlabsize(5pt)) ///
	(scatter _Foodgroup owncons if _Foodgroup == 9, mcolor(sienna) msize(medsmall) msymbol(O) mlab(own_perc) mlabposition(9) mlabcolor(sienna) mlcolor(black) mlwidth(vthin) mlabsize(5pt)) ///
	, xline(20 40 60 80 100, lwidth(vthin) lcolor(gs14)) subtitle(,bcolor(gs15)) ytitle("") xtitle("Consumption (% of households)", size(7pt)) ylab(1(1)9, labsize(7pt) valuelabel nogrid angle(0)) xlab(0 20 40 60 80 100, labsize(6pt)) plotregion(margin(t+2)) graphregion(color(white)) ///
	legend(rows(2) size(6pt) region(lcolor(none) lstyle(none)) position(6) bmargin(l-45 r-0) bexpand symysize(2) symxsize(3) order(1 "Purchases" 2 "Exclusively non-purchases" 13 "" 9 "Exclusively from" "purchases" 11 "Own production" 10 "Gifts/in-kind")) xsize(8.8cm) ysize(7cm)
	
graph export "${workdir}/graphs/FG_global.png", replace
graph export "${workdir}/graphs/FG_global.pdf", replace

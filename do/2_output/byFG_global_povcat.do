/*******************************************************************************
Replication File for 
- Fig. 2 | Consumption of nine food groups and sourcing by poverty category.
*******************************************************************************/
use "${datadir}/graphs and tables/byFG_bypovcat.dta", clear

* Fig. 2: 
gen zero = 0

graph set window fontface "Helvetica"
twoway ///
	(rbar zero  purchases povcat, horizontal barw(0.6) bfcolor(midblue*0.6) lcolor(midblue)) ///
	(rbar purchases consumption povcat, horizontal barw(0.6) bfcolor(midgreen*0.6) lcolor(midgreen)) ///
	(rcap ll_purch ul_purch povcat, horizontal lwidth(vthin) lcolor(midblue)) ///
	(rcap ll_purch_only ul_purch_only povcat, horizontal lwidth(vthin) lcolor(midblue)) ///
	(rcap ll_rec ul_rec povcat, horizontal lwidth(vthin) lcolor(gold)) ///
	(rcap ll_own ul_own povcat, horizontal lwidth(vthin) lcolor(sienna)) ///
	(scatter povcat purchases_only, mcolor(midblue*1.1) msize(vsmall) msymbol(D)) ///
	(scatter povcat owncons, mcolor(sienna) msize(vsmall) msymbol(o)) ///
	(scatter povcat receivings, mcolor(gold) msize(vsmall) msymbol(o)) ///
	/*(rcap ll_consumption ul_consumption povcat, horizontal lcolor(midgreen))*/ ///
	, by(_Foodgroup, /*iscale(*0.6)*/ note("") graphregion(color(white))) xline(20 40 60 80 100, lwidth(vthin) lcolor(gs14)) subtitle(, size(8pt) bcolor(gs15)) ytitle("Household per capita consumption expenditure in USD (2021 PPPs)", size(7pt)) xtitle("Consumption (% of households)", size(7pt)) ylab(1 2 3 4, labsize(7pt) valuelabel nogrid angle(0)) xlab(0 20 40 60 80 100, labsize(7pt)) graphregion(color(white)) graphregion(color(white)) ///
	legend( region(lstyle(none))  rows(2) size(5pt) symysize(2) symxsize(3) order(1 "Consumption from purchases" 2 "Consumption exclusively from other sources" 10 "" 7 "Consumption exclusively from purchases" 8 "Consumption from own production" 9 "Consumption from gifts/in-kind")) xsize(18.0cm) ysize(10.0cm)
graph export "${workdir}/graphs/FG_global_povcat.png", replace
graph export "${workdir}/graphs/FG_global_povcat.pdf", replace

/*******************************************************************************
Replication File for 
- Fig. S7 | Consumption and sourcing of nine food groups by household agricultural status. 
*******************************************************************************/
use "${datadir}/graphs and tables/FG_global_byfarm.dta", clear

* Calculate proportions
gen purchshr = (purchases/consumption)*100
gen purchonlyshr = (purchases_only/consumption)*100
gen ownshr = (owncons/consumption)*100
gen inkindshr = (receivings/consumption)*100
lab var purchshr "Share of consumers who purchase FG (in %)"
lab var purchonlyshr "Share of consumers who only purchase FG (in %)"
lab var ownshr "Share of consumers who own consume FG (in %)"
lab var inkindshr "Share of consumers who receive FG from gifts/in-kind (in %)"


* Fig. S7 
gen zero = 0

graph set window fontface "Helvetica"
twoway ///
	(rbar zero purchases occup_agr_any, horizontal barw(0.6) bfcolor(midblue*0.6) lcolor(midblue)) ///
	(rbar purchases consumption occup_agr_any, horizontal barw(0.6) bfcolor(midgreen*0.6) lcolor(midgreen)) ///
	(rcap ll_rec ul_rec occup_agr_any, horizontal lwidth(thin) lcolor(gold*0.6)) ///
	(rcap ll_purch_only ul_purch_only occup_agr_any, horizontal lwidth(thin) lcolor(midblue)) ///
	(rcap ll_own ul_own occup_agr_any, horizontal lwidth(thin) lcolor(sienna*0.6)) ///
	(scatter occup_agr_any purchases_only, mcolor(midblue*1.1) msize(medsmall) msymbol(D)) ///
	(scatter occup_agr_any owncons, mcolor(sienna) msize(medium) msymbol(o)) ///
	(scatter occup_agr_any receivings, mcolor(gold) msize(medium) msymbol(o)) ///
	(rcap ll_consumption ul_consumption occup_agr_any, horizontal lcolor(midgreen)) ///
	, by(_Foodgroup, note("") subtitle(,size(7pt)) graphregion(color(white))) xline(20 40 60 80 100, lwidth(vthin) lcolor(gs14)) subtitle(,bcolor(gs15)) ytitle("") xtitle("Consumption (% of households)", size(7pt)) ylab(0 1, valuelabel nogrid angle(0)) xlab(0 20 40 60 80 100) graphregion(color(white)) graphregion(color(white)) ///
	legend(region(lstyle(none)) rows(2) size(7pt) symysize(2) symxsize(3) order(1 "Consumption from purchases" 2 "Consumption exclusively from non-purchases" 10 "" 6 "Consumption exclusively from purchases" 7 "Consumption from own production" 8 "Consumption from gifts/in-kind")) xsize(18cm) ysize(9cm)
	
graph export "${workdir}/graphs/FG_global_byfarm.png", replace
graph export "${workdir}/graphs/FG_global_byfarm.pdf", replace

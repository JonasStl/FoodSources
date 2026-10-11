/*******************************************************************************
Replication File for 
- Fig. S9 | Consumption and sourcing of nine food groups by rural-urban location. 
*******************************************************************************/
use "$datadir/graphs and tables/FG_global_urban.dta", clear


* Calculate proportions
gen purchshr = (purchases/consumption)*100
gen purchonlyshr = (purchases_only/consumption)*100
gen ownshr = (owncons/consumption)*100
gen inkindshr = (receivings/consumption)*100
lab var purchshr "Share of consumers who purchase FG (in %)"
lab var purchonlyshr "Share of consumers who only purchase FG (in %)"
lab var ownshr "Share of consumers who own consume FG (in %)"
lab var inkindshr "Share of consumers who receive FG from gifts/in-kind (in %)"


* Fig. S9:
gen zero = 0

graph set window fontface "Helvetica"
twoway ///
	(rbar zero purchases urban, horizontal barw(0.6) bfcolor(midblue*0.6) lcolor(midblue)) ///
	(rbar purchases consumption urban, horizontal barw(0.6) bfcolor(midgreen*0.6) lcolor(midgreen)) ///
	(rcap ll_rec ul_rec urban, horizontal lwidth(thin) lcolor(gold*0.6)) ///
	(rcap ll_purch_only ul_purch_only urban, horizontal lwidth(thin) lcolor(midblue)) ///
	(rcap ll_own ul_own urban, horizontal lwidth(thin) lcolor(sienna*0.6)) ///
	(scatter urban purchases_only, mcolor(midblue*1.1) msize(medsmall) msymbol(D)) ///
	(scatter urban owncons, mcolor(sienna) msize(medium) msymbol(o)) ///
	(scatter urban receivings, mcolor(gold) msize(medium) msymbol(o)) ///
	(rcap ll_consumption ul_consumption urban, horizontal lcolor(midgreen)) ///
	, by(_Foodgroup, note("") subtitle(,size(7pt)) graphregion(color(white))) xline(20 40 60 80 100, lwidth(vthin) lcolor(gs14)) subtitle(,bcolor(gs15)) ytitle("") xtitle("Consumption (% of households)", size(7pt)) ylab(0 1, valuelabel nogrid angle(0)) xlab(0 20 40 60 80 100) graphregion(color(white)) graphregion(color(white)) ///
	legend(region(lstyle(none)) rows(2) size(7pt) symysize(2) symxsize(3) order(1 "Consumption from purchases" 2 "Consumption exclusively from non-purchases" 10 "" 6 "Consumption exclusively from purchases" 7 "Consumption from own production" 8 "Consumption from gifts/in-kind")) xsize(18cm) ysize(9cm)
	
graph export "$workdir/graphs/Figure_S9.png", replace
graph export "$workdir/graphs/Figure_S9.pdf", replace


/*
Figure Notes:

Fig. S9. Consumption and sourcing of nine food groups by rural–urban location.
Panels compare rural and urban households. The horizontal bar shows the share of households that consumed the food group: the blue segment is the share that consumed it from purchases (whether or not they also used other sources), while the green segment is the additional share that consumed it only from non-purchase sources; blue + green equals total consumption. The blue diamond marks the share that obtained the food group exclusively from purchases. Brown dots and yellow dots show the shares that obtained any of the food group from own production and from gifts/in-kind, respectively. Thin lines indicate 95% confidence intervals for the displayed estimates. Sample sizes: N = 1,125,971 for consumption, purchases, purchases-only, and own production, and N = 795,130 for gifts/in-kind.
*/

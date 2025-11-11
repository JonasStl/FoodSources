/*******************************************************************************
Replication File for 
- Fig. S3 | Sourcing of food items by food group. 
*******************************************************************************/
use "${datadir}/graphs and tables/byFGitem_global.dta", clear

// Create labels
gen purchshr = string(round(Ncons_shr_purch)) + "%"
gen ownshr = string(round(Ncons_shr_own)) + "%"
gen recshr = string(round(Ncons_shr_rec)) + "%"

gen xnotes = 50

gen notes1 = "({it:n{sub:1} = " + string(sample_purch, "%12.0fc") + " ; " + "n{sub:2} = " + string(sample_rec, "%12.0fc") + "})"

* SI Figure 3
graph set window fontface "Helvetica"
twoway ///
	(rcap ll_Ncons_shr_purch ul_Ncons_shr_purch _Foodgroup, horizontal lcolor(midblue*0.8) lwidth(thin)) ///
	(rcap ll_Ncons_shr_own ul_Ncons_shr_own _Foodgroup, horizontal lcolor(sienna*0.8) lwidth(thin)) ///
	(rcap ll_Ncons_shr_rec ul_Ncons_shr_rec _Foodgroup, horizontal lcolor(gold*0.8) lwidth(thin)) ///
	(scatter _Foodgroup Ncons_shr_purch, mcolor(midblue) msymbol(d) mlab(purchshr) mlabposition(12) mlabcolor(midblue) mlcolor(black) mlwidth(vthin)) ///
	(scatter _Foodgroup Ncons_shr_own, mcolor(sienna) msize(medium) msymbol(o) mlab(ownshr) mlabposition(3) mlabcolor(sienna) mlcolor(black) mlwidth(vthin)) ///
	(scatter _Foodgroup Ncons_shr_rec, mcolor(gold) msize(medium) msymbol(o) mlab(recshr) mlabposition(12) mlabcolor(gold) mlcolor(black) mlwidth(vthin)) ///
	(scatter _Foodgroup xnotes, msymbol(i) mlab(notes1) mlabpos(0) mlabcolor(black) mlabsize(5pt)) ///
	, xline(20 40 60 80 100, lwidth(vthin) lcolor(gs14)) subtitle(,bcolor(gs15)) ytitle("") xtitle("Share of consumed items from") ylab(1(1)9, valuelabel nogrid angle(0)) xlab(0 20 40 60 80 100) yscale(reverse) plotregion(margin(t+2)) graphregion(color(white)) graphregion(color(white)) ///
	legend(region(lstyle(none)) cols(3) size(small) position(6) bmargin(l-45 r-0) bexpand symysize(2) symxsize(3) order(4 "Purchases ({it:sample=n{sub:1}})" 5 "Own production ({it:sample=n{sub:1}})"  6 "Gifts/in-kind ({it:sample=n{sub:2}})")) xsize(12.0cm) ysize(7cm)
graph export "${workdir}/graphs/FGitem_global.png", replace
graph export "${workdir}/graphs/FGitem_global.pdf", replace

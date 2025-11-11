/*******************************************************************************
Replication File for
- Fig. S9 | Food item sources by food group and agricultural status. 
*******************************************************************************/
use "${datadir}/graphs and tables/byFGitem_global_byfarm.dta", clear


// Create labels
gen purchshr = string(round(Ncons_shr_purch)) + "%"
gen ownshr = string(round(Ncons_shr_own)) + "%"
gen recshr = string(round(Ncons_shr_rec)) + "%"

lab def occbin 0 "NonAg HH" 1 "Ag HH", modify

gen ynotes = 0.5
gen xnotes = 100

gen notes1 = "{it:n{sub:1} = " + string(sample_purch, "%12.0fc") + "}"
gen notes2 = "{it:n{sub:2} = " + string(sample_rec, "%12.0fc") + "}"


* SI Figure 9:
graph set window fontface "Helvetica"
twoway ///
	(rcap ll_Ncons_shr_purch ul_Ncons_shr_purch occup_agr_any, horizontal lcolor(midblue) lwidth(medium)) ///
	(rcap ll_Ncons_shr_own ul_Ncons_shr_own occup_agr_any, horizontal lcolor(sienna) lwidth(medium)) ///
	(rcap ll_Ncons_shr_rec ul_Ncons_shr_rec occup_agr_any, horizontal lcolor(gold) lwidth(medium)) ///
	(scatter occup_agr_any Ncons_shr_purch if occup_agr_any == 1, mcolor(midblue) msize(large) msymbol(d) mlab(purchshr) mlabpos(6) mlabcolor(midblue) mlabsize(7pt) mlabgap(3pt)) ///
	(scatter occup_agr_any Ncons_shr_own if occup_agr_any == 1, mcolor(sienna) msize(large) msymbol(o) mlab(ownshr) mlabpos(3) mlabcolor(sienna) mlabsize(7pt) mlabgap(3pt)) ///
	(scatter occup_agr_any Ncons_shr_rec if occup_agr_any == 1, mcolor(gold) msize(large) msymbol(o) mlab(recshr) mlabpos(6) mlabcolor(gold) mlabsize(7pt)  mlabgap(0pt) mlabgap(3pt)) ///
	(scatter occup_agr_any Ncons_shr_purch if occup_agr_any == 0, mcolor(midblue) msize(large) msymbol(d) mlab(purchshr) mlabpos(12) mlabcolor(midblue) mlabsize(7pt) mlabgap(3pt)) ///
	(scatter occup_agr_any Ncons_shr_own if occup_agr_any == 0, mcolor(sienna) msize(large) msymbol(o) mlab(ownshr) mlabpos(4) mlabcolor(sienna) mlabsize(7pt) mlabgap(3pt)) ///
	(scatter occup_agr_any Ncons_shr_rec if occup_agr_any == 0, mcolor(gold) msize(large) msymbol(o) mlab(recshr) mlabpos(12) mlabcolor(gold) mlabsize(7pt) mlabgap(3pt)) ///
	(scatter occup_agr_any Ncons_shr_own if occup_agr_any == 0  & inlist(_Foodgroup,0), mcolor(sienna) msize(large) msymbol(o) mlab(ownshr) mlabpos(5) mlabcolor(sienna) mlabsize(7pt) mlabgap(3pt)) ///
	(scatter occup_agr_any Ncons_shr_rec if occup_agr_any == 0  & inlist(_Foodgroup,0), mcolor(gold) msize(large) msymbol(o) mlab(recshr) mlabpos(12) mlabcolor(gold) mlabsize(7pt) mlabgap(3pt)) ///
	(scatter ynotes xnotes, msymbol(i) mlab(notes1) mlabpos(10) mlabcolor(black) mlabsize(5pt) mlabgap(1pt)) ///
	(scatter ynotes xnotes, msymbol(i) mlab(notes2) mlabpos(8) mlabcolor(black) mlabsize(5pt) mlabgap(1pt)) ///
	, by(_Foodgroup, note("") graphregion(color(white)) subtitle(,size(10pt))) xline(20 40 60 80 100, lwidth(vthin) lcolor(gs14)) subtitle(,bcolor(gs15)) ytitle("") xtitle("% of consumed food items", size(7pt)) yscale(range(-0.1 1)) ylab(0 1, valuelabel labsize(7pt) nogrid angle(0)) xlab(0 20 40 60 80 100) graphregion(color(white) margin(t-50 b-20)) ///
	legend(region(lstyle(none)) rows(1) size(7pt) symysize(1) symxsize(3) order(4 "Consumption from purchases ({it:sample=n{sub:1}})" 5 "Consumption from own production ({it:sample=n{sub:1}})" 7 "Consumption from gifts/in-kind ({it:sample=n{sub:2}})")) xsize(18cm) ysize(9cm)
	
graph export "${workdir}/graphs/FGitem_global_byfarm.png", replace
graph export "${workdir}/graphs/FGitem_global_byfarm.pdf", replace

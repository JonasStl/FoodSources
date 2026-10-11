/*******************************************************************************
Replication File for 
- Fig. 1 | Food sourcing variation across countries and food groups.
*******************************************************************************/

* Panel a: country-level sourcing, by World Bank income group.
do "${workdir}/do/_prepare_table1_wdi.do"

twoway ///
    (scatter onlypurch anyown if incomelevelname == "Low income", ///
        mcolor("0 158 115%80") msymbol(O) msize(medsmall) ///
        mlabel(country) mlabsize(tiny) mlabcolor("0 158 115") mlabposition(12)) ///
    (scatter onlypurch anyown if incomelevelname == "Lower middle income", ///
        mcolor("180 30 90%80") msymbol(D) msize(medsmall) ///
        mlabel(country) mlabsize(tiny) mlabcolor("180 30 90") mlabposition(12)) ///
    (scatter onlypurch anyown if incomelevelname == "Upper middle income", ///
        mcolor("0 114 178%80") msymbol(T) msize(medsmall) ///
        mlabel(country) mlabsize(tiny) mlabcolor("0 114 178") mlabposition(12)) ///
    (scatter onlypurch anyown if country == "Full Sample", ///
        mcolor("0 0 0") msymbol(Oh) msize(medium) ///
        mlabel(country) mlabsize(tiny) mlabcolor("0 0 0") mlabposition(12)), ///
    xtitle("Households with any own consumption (%)", size(7pt)) ///
    ytitle("Households exclusively purchasing food items (%)", size(7pt)) ///
    xlabel(0(20)100, labsize(7pt) grid) ///
    ylabel(0(20)100, labsize(7pt) grid angle(horizontal)) ///
    xscale(range(0 100)) yscale(range(0 100)) ///
    legend(order(1 "Low income" 2 "Lower middle income" ///
                 3 "Upper middle income" 4 "World sample average") ///
           cols(1) size(6pt) region(lcolor(none)) ring(0) position(1)) ///
    graphregion(color(white)) plotregion(color(white) lcolor(gs12)) ///
    scheme(s1color) xsize(8.2cm) ysize(7cm) ///
    subtitle("{bf:a}", size(10pt) position(11) span)

graph export "${workdir}/graphs/Figure_1a.png", replace
graph export "${workdir}/graphs/Figure_1a.pdf", replace

* Panel b: consumption and sourcing of nine food groups.
use "$datadir/graphs and tables/byFG_global.dta", clear


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
	legend(rows(2) size(6pt) region(lcolor(none) lstyle(none)) position(6) bmargin(l-45 r-0) bexpand symysize(2) symxsize(3) order(1 "Purchases" 2 "Exclusively non-purchases" 13 "" 9 "Exclusively from" "purchases" 11 "Own production" 10 "Gifts/in-kind")) xsize(8.2cm) ysize(7cm) subtitle("{bf:b}", size(10pt) position(11) span)
	
graph export "$workdir/graphs/Figure_1b.png", replace
graph export "$workdir/graphs/Figure_1b.pdf", replace


/* Figure notes:

Fig. 1 | Food sourcing variation across countries and food groups.
Food groups are ordered top to bottom by the share of households that obtained the item from own production (highest first). For each group, the horizontal bar shows the percent of households that consumed the food (x-axis). The blue segment is the share that consumed the item from purchases (whether or not other sources were used). The green segment is the additional share consuming it only from non-purchase sources. Thus, blue + green = total consumption. The blue diamond marks the share consuming the item exclusively from purchases. Brown and yellow dots mark the shares consuming any of the item from own production and from gifts/in-kind, respectively. 
Capped spikes show 95% confidence intervals. Sample sizes: N = 1,175,967 for total consumption, purchases, purchases-only, and own production and N = 845,126 for gifts/in-kind.
*/

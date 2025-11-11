/*******************************************************************************
Replication File for 
- Extended Data Fig. 1 | Country‐level consumption and sourcing of nine food groups. 
- Fig. S2 | Relationship between food group consumption and proportions from purchases and own consumption. 
*******************************************************************************/
use "${datadir}/graphs and tables/byFG_bycountry.dta", clear


* Extended Data Fig. 1 
decode country_enc, gen(country)
decode _Foodgroup, gen(Foodgroup)
lab var ownshr "Share from own production"
lab var purchshr "Share from purchases"


*** Combined of all four graph
capture drop _dummy z0
gen byte _dummy = 1
label define D 1 " "
label values _dummy D
gen byte z0 = 0

gen Foodgroup_num = ""
replace Foodgroup_num = "(1) Cereals" if Foodgroup == "Cereals"
replace Foodgroup_num = "(2) Roots, tubers, and plantains" if Foodgroup == "Roots, tubers, and plantains"
replace Foodgroup_num = "(3) Pulses, nuts and seeds" if Foodgroup == "Pulses, nuts and seeds"
replace Foodgroup_num = "(4) Vegetables" if Foodgroup == "Vegetables"
replace Foodgroup_num = "(5) Fruits" if Foodgroup == "Fruits"
replace Foodgroup_num = "(6) Meat" if Foodgroup == "Meat"
replace Foodgroup_num = "(7) Fish and seafood" if Foodgroup == "Fish and seafood"
replace Foodgroup_num = "(8) Milk and dairy products" if Foodgroup == "Milk and dairy products"
replace Foodgroup_num = "(9) Eggs" if Foodgroup == "Eggs"

* labels-only strip (no ramp, no tiles)
heatplot z0 country _dummy, discrete cuts(0 1) ///
    colors(white white) legend(off) ///
    yscale(noline reverse) xscale(noline) ///
    ylabel(, valuelabel angle(0) labsize(10pt)) xlabel(none) ///
    ytitle("") xtitle("") ///
    plotregion(margin(0 0 5 11)) graphregion(color(white) margin(0 0 0 0)) ///
    name(H_labels, replace) ysize(5) xsize(1) fxsize(12) fysize(220) nodraw

heatplot purchshr country Foodgroup_num,  ///
    discrete colors(white blue) ramp(top title("Share from purchases", size(10pt)) subtitle("") graphregion(color(white)) space(8) length(15) labels(,labsize(8pt))) ///
    cuts(0(10)100) yscale(noline reverse) xscale(noline) plotregion(margin(0 0 0 -5)) graphregion(color(white)) ///
    ylabel(none) xlabel(, noticks angle(45) labsize(9pt)) ytitle("") xtitle("") values(format(%9.0f) size(7pt))  ///
    name(H_purchshr, replace) ysize(5) xsize(4) missing(label("Missing") color(gs13)) nodraw
	
heatplot ownshr country Foodgroup_num,  ///
    discrete colors(white sienna) ramp(top title("Share from own production", size(10pt)) subtitle("") graphregion(color(white)) space(8) length(15) labels(,labsize(8pt))) /// 
    cuts(0(10)100) yscale(noline reverse) xscale(noline) plotregion(margin(0 0 0 -5)) graphregion(color(white)) ///
    ylabel(none) xlabel(, noticks angle(45) labsize(9pt)) ytitle("") xtitle("") values(format(%9.0f) size(7pt)) ///
    name(H_ownshr, replace) ysize(5) xsize(4) missing(label("Missing") color(gs13)) nodraw
	
heatplot inkindshr country Foodgroup_num,  ///
    discrete colors(white gold)  ramp(top title("Share from gifts/in-kind", size(10pt)) subtitle("") graphregion(color(white)) space(8) length(15) labels(,labsize(8pt))) ///
    cuts(0(10)100) yscale(noline reverse) xscale(noline) plotregion(margin(0 0 0 -5)) graphregion(color(white)) ///
    ylabel(none) xlabel(, noticks angle(45) labsize(9pt)) ytitle("") xtitle("") values(format(%9.0f) size(7pt))  ///
    name(H_inkindshr, replace) ysize(5) xsize(4) missing(label("Missing") color(gs13)) nodraw
	
heatplot consumption country Foodgroup_num,  ///
    discrete colors(white green) ramp(top title("Consumption (% of households)", size(10pt)) subtitle("") graphregion(color(white)) space(8) length(15) labels(,labsize(8pt))) ///
    cuts(0(10)100) yscale(noline reverse) xscale(noline) plotregion(margin(0 0 0 -5)) graphregion(color(white)) ///
    ylabel(none) xlabel(, noticks angle(45) labsize(9pt)) ytitle("") xtitle("") values(format(%9.0f) size(7pt)) ///
    name(H_consshr, replace) ysize(5) xsize(4) missing(label("Missing") color(gs13)) 
	
graph combine H_labels H_consshr H_purchshr H_ownshr H_inkindshr, cols(5) xcommon ycommon ///
    imargin(zero) graphregion(color(white) margin(l+7 b-3 t-2)) ysize(21.5cm) xsize(18cm)
graph export "$workdir/graphs/FG_country_heat.pdf", replace
graph export "$workdir/graphs/FG_country_heat.png", replace

/* Figure Notes:
Extended Data Fig. 1 | Country‐level consumption and sourcing of nine food groups. 
Rows list country–year surveys sorted alphabetically. Columns list the nine food groups. The four adjacent heatmaps report, from left to right: (1) total consumption (percent of households that consumed the group), (2) share of purchase households from total cosumption households in (1), (3) share of own consumption households from total cosumption households in (1), and (4) share of gifts/in-kind households from total cosumption households in (1). Each cell shows the survey-weighted percentages: darker shading = larger share. Numbers in cells are rounded to integers. Light grey cells indicate no data for that source. Note that own consumption estimates in Indonesia represent all non-purchases, including gifts and in-kind.
Sample sizes: N = 1,107,826 for total consumption, purchases, and own consumption and N = 774,501 for gifts/in-kind.

No gifts/in-kind: Bhutan, Cook Islands, Ghana, Rwanda
Only non-purchases: Indonesia
Different recall periods: Ghana, Rwanda
*/


* Fig. S2 | Relationship between food group consumption and proportions from purchases and own consumption. 
graph set window fontface "Helvetica"

// relative
twoway  (qfitci purchshr consumption, lcolor(midblue) lpattern(solid) acolor(gs14)) || ///
	(qfitci ownshr consumption, lcolor(sienna) lpattern(solid) acolor(gs14)) || ///
	(scatter purchshr consumption, mlabel(country_enc) msize(vsmall) mlabsize(5pt) mcolor(midblue) mlabcolor(midblue) mlabposition(11)) ///
	(scatter ownshr consumption if !inlist(country_enc,7,19), mlabel(country_enc) msize(vsmall) mlabsize(5pt) mcolor(sienna) mlabcolor(sienna) mlabposition(5)) ///
	(scatter ownshr consumption if inlist(country_enc,7,19), mlabel(country_enc) msize(vsmall) mlabsize(5pt) mcolor(brown) mlabcolor(brown) mlabposition(5)), ///
	by(_Foodgroup, iscale(*0.6) note("") graphregion(color(white))) xtitle("Consumption (% of households)", size(7pt)) subtitle(,bcolor(gs15)) ytitle("Sourcing among consumers (%)", size(7pt)) ylabel(0(20)100,angle(0) labsize(7pt) grid) xlabel(0(20)100,labsize(7pt) grid) legend(region(lstyle(none)) size(7pt) ring(0) position(3) rows(1) order(5 "% from purchases" 6 "% from own production" 7 "% from non-purchases")) graphregion(color(white) margin(r+2)) xsize(18.0cm) ysize(13.0cm)
	
/* Figure Notes:
Fig. S2 | Relationship between food group consumption and proportions from purchases and own consumption. 
Each marker is a survey-weighted population-adjusted design-corrected country mean for each country and food group. The x-axis is the proportion of households that consume a food group in the respective country. The y-axis is the proportion of households that source each food group from purchases or their own production as a share from all consuming households (they x-axis). Blue refers to purchases and brown to own production. The lines indicate quadratic fits and the grey bands are 95% confidence intervals for those smooths. Sample size: N = 1,107,826.
*/

graph export "${workdir}/graphs/FG_country_scatter.png", replace
graph export "${workdir}/graphs/FG_country_scatter.pdf", replace


	
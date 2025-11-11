/*******************************************************************************
Replication File for
- Fig. S13 | Food sources using the HDDS versus the MDDW indicator by country
*******************************************************************************/

use "${datadir}/graphs and tables/DD_country.dta", clear
drop if inlist(country,"Tajikistan 2009","Jamaica 2019","El Salvador 2014")

gen diversitymsr = "HDDS"

append using "${datadir}/graphs and tables/MDDW_country.dta"
replace diversitymsr = "MDDW" if diversitymsr == ""


gen cntry_divmsr = country + " - " + diversitymsr
encode cntry_divmsr, gen(cntry_divmsr_enc)


* Generate common variables
gen DDS = DDS_hlthy
replace DDS = MDDW if DDS == .
gen se_DDS = DDS_hlthy
replace se_DDS = MDDW if se_DDS == .
gen ll_DDS = DDS_hlthy
replace ll_DDS = MDDW if ll_DDS == .
gen ul_DDS = DDS_hlthy
replace ul_DDS = MDDW if ul_DDS == .

gen DDS_own = DDS_hlthy_own
replace DDS_own = MDDW_own if DDS_own == .
gen se_DDS_own = se_DDS_hlthy_own
replace se_DDS_own = se_MDDW_own if se_DDS_own == .
gen ll_DDS_own = ll_DDS_hlthy_own
replace ll_DDS_own = ll_MDDW_own if ll_DDS_own == .
gen ul_DDS_own = ul_DDS_hlthy_own
replace ul_DDS_own = ul_MDDW_own if ul_DDS_own == .

gen DDS_purch = DDS_hlthy_purch
replace DDS_purch = MDDW_purch if DDS_purch == .
gen se_DDS_purch = se_DDS_hlthy_purch
replace se_DDS_purch = se_MDDW_purch if se_DDS_purch == .
gen ll_DDS_purch = ll_DDS_hlthy_purch
replace ll_DDS_purch = ll_MDDW_purch if ll_DDS_purch == .
gen ul_DDS_purch = ul_DDS_hlthy_purch
replace ul_DDS_purch = ul_MDDW_purch if ul_DDS_purch == .


* Averages
sum DDS_hlthy MDDW DDS_hlthy_own MDDW_own DDS_hlthy_purch MDDW_purch
sum own_perc purch_perc if diversitymsr == "HDDS" 
sum own_perc purch_perc if diversitymsr == "MDDW" 


* Fig. S13:
gen zero = 0

// background shades
gen double _pairy = . 
replace _pairy = cntry_divmsr_enc + 0.5 if mod(cntry_divmsr_enc,2)==1  
gen _x0 = 0
gen _x1 = 8.5  

gen _xlo = -4.5
gen _xhi = 8.5 
gen pair = ceil(cntry_divmsr_enc/2)
bys pair: egen yctr = mean(cntry_divmsr_enc)
gen oddpair = mod(pair, 2)==1


//graph
graph set window fontface "Helvetica"
twoway rbar _xlo _xhi cntry_divmsr_enc if oddpair, horizontal barw(1.0) color(gs14) lcolor(none) ||  ///  
	rbar zero DDS_purch cntry_divmsr_enc, horizontal barw(0.7) color(midblue*0.5) || ///
	rbar DDS_purch DDS cntry_divmsr_enc, horizontal barw(0.7) color(midgreen*0.5)  || ///
	scatter cntry_divmsr_enc DDS_own, msymbol(i) mlabel(ownperc) mlabposition(3) mlabformat(%9.0f) mlabcolor(sienna) mlabsize(5pt)  mlabgap(1pt) || ///
	scatter cntry_divmsr_enc DDS_purch, msymbol(i) mlabel(purchperc) mlabposition(9) mlabformat(%9.0f) mlabcolor(midblue*1.5) mlabsize(5pt)  mlabgap(1pt) || ///
	scatter cntry_divmsr_enc zero, msymbol(i) mlabel(cntry_divmsr) mlabsize(6pt) mlabcolor(black) mlabposition(9) || ///
	scatter cntry_divmsr_enc DDS_own, mcolor(sienna) msize(vsmall) msymbol(o) || ///
	, xsize(18cm) ysize(21.0cm) yscale(reverse noline)  ylabel(none) ytick(none) xscale(range(-2 8)) xlabel(0(2)8, labsize(7pt)) plotregion(margin(r+2.5)) graphregion(margin(t-5 b-5 l-2) color(white)) ///
	legend(region(lstyle(none))  size(7pt) rows(1) position(6) bmargin(l-13 r-3) bexpand placement(8) symysize(2)  symxsize(3) ///
	order(7 "HDDS/MDDW from own consumption" "{it:(number is % from tot. HDDS/MDDW)}" 2 "HDDS/MDDW from purchases" "{it:(number is % from tot. HDDS/MDDW)}" 3 "HDDS/MDDW not" "purchased")) ///
	ytitle("") xtitle("Healthy HDDS (0-9)", size(8pt)) 
graph export "${workdir}/graphs/MDDW_country.png", replace
graph export "${workdir}/graphs/MDDW_country.pdf", replace


*** Fig. SX (not included) ***
capture drop _dummy z0
gen byte _dummy = 1
label define D 1 " "
label values _dummy D
gen byte z0 = 0

* labels-only strip (no ramp, no tiles)
heatplot z0 country _dummy, discrete cuts(0 1) ///
    colors(white white) legend(off) ///
    yscale(reverse noline) xscale(noline) ///
    ylabel(, valuelabel angle(0) labsize(10pt)) xlabel(none) ///
    ytitle("") xtitle("") ///
    plotregion(margin(0 0 -7 3)) graphregion(color(white) margin(0 0 0 0)) ///
    name(H_labels, replace) ysize(5) xsize(1) fxsize(12) fysize(110) nodraw

heatplot purch_perc country diversitymsr,  ///
    discrete colors(white blue) ramp(top title("Share from purchases", size(10pt)) subtitle("") graphregion(color(white)) space(8) length(15) labels(,labsize(8pt))) ///
    cuts(0(10)100) yscale(reverse noline) xscale(noline) plotregion(margin(0 0 0 -5)) graphregion(color(white)) ///
    ylabel(none) xlabel(, noticks angle(0) labsize(9pt)) ytitle("") xtitle("") values(format(%9.0f) size(7pt))  ///
    name(H_purchshr, replace) ysize(5) xsize(4) missing(label("Missing") color(gs10)) nodraw
	
heatplot own_perc country diversitymsr,  ///
    discrete colors(white sienna) ramp(top title("Share from own production", size(10pt)) subtitle("") graphregion(color(white)) space(8) length(15) labels(,labsize(8pt))) /// 
    cuts(0(10)100) yscale(reverse noline) xscale(noline) plotregion(margin(0 0 0 -5)) graphregion(color(white)) ///
    ylabel(none) xlabel(, noticks angle(0) labsize(9pt)) ytitle("") xtitle("") values(format(%9.0f) size(7pt)) ///
    name(H_ownshr, replace) ysize(5) xsize(4) missing(label("Missing") color(gs10)) nodraw
	
heatplot DDS country diversitymsr,  ///
    discrete colors(white green) ramp(top title("HDDS (0-9) / MDDW (0-10)", size(10pt)) subtitle("") graphregion(color(white)) space(8) length(15) labels(,labsize(8pt))) ///
    cuts(0(1)10) yscale(reverse noline) xscale(noline) plotregion(margin(0 0 0 -5)) graphregion(color(white)) ///
    ylabel(none) xlabel(, noticks angle(0) labsize(9pt)) ytitle("") xtitle("") values(format(%9.1f) size(7pt)) ///
    name(H_consshr, replace) ysize(5) xsize(4) missing(label("Missing") color(gs10)) nodraw
	

graph combine H_labels H_consshr H_purchshr H_ownshr , rows(1) xcommon ycommon ///
    imargin(zero) graphregion(color(white) margin(l+7)) ysize(22.5cm) xsize(18cm)
graph export "${workdir}/graphs/MDDW_country_heatmap.png", as(pdf) fontface("Helvetica") replace


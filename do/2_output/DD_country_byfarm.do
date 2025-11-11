/*******************************************************************************
Replication File for
- Fig. 4 | Country-level dietary diversity and sourcing by household agricultural activity.
- Fig. S10 | Country-level dietary diversity and sourcing by household agricultural activity. 
*******************************************************************************/
use "${datadir}/graphs and tables/DD_bycountry_byfarm.dta", clear

decode _occup, gen(occupation)

*** Fig. S10
gen cntry_occmsr = country + " - " + occupation
encode cntry_occmsr, gen(cntry_occmsr_enc)

// background shades
gen double _pairy = . 
replace _pairy = cntry_occmsr_enc + 0.5 if mod(cntry_occmsr_enc,2)==1  
gen zero = 0
gen _x0 = 0
gen _x1 = 8.5  


gen _xlo = -4.5
gen _xhi = 8.5 
gen pair = ceil(cntry_occmsr_enc/2)
bys pair: egen yctr = mean(cntry_occmsr_enc)
gen oddpair = mod(pair, 2)==1


// with spikes
twoway rbar _xlo _xhi cntry_occmsr_enc if oddpair, horizontal barw(1.0) color(gs14) lcolor(none) ||  ///  
	rbar zero DDS_hlthy_purch cntry_occmsr_enc, horizontal barw(0.7) color(midblue*0.5) || ///
	rbar DDS_hlthy_purch DDS_hlthy cntry_occmsr_enc, horizontal barw(0.7) color(midgreen*0.5)  || ///
	rspike ll_DDS_hlthy_own ul_DDS_hlthy_own cntry_occmsr_enc,  horizontal lcolor(sienna*0.8) lwidth(vthin) || ///
	rspike ll_DDS_hlthy_purch ul_DDS_hlthy_purch cntry_occmsr_enc,  horizontal lcolor(midblue*0.8) lwidth(vthin) || ///
	rspike ll_DDS_hlthy ul_DDS_hlthy cntry_occmsr_enc,  horizontal lcolor(midgreen*0.8) lwidth(vthin) || ///
	scatter cntry_occmsr_enc ul_DDS_hlthy_own if !inlist(country,"Ethiopia 2019","Burkina Faso 2021","Guinea-Bissau 2021","Bhutan 2012") | occupation != "Ag HH", msymbol(i) mlabel(ownperc) mlabposition(3) mlabformat(%9.0f) mlabcolor(sienna) mlabsize(5pt)  mlabgap(0pt) || ///
	scatter cntry_occmsr_enc ll_DDS_hlthy_purch if !inlist(country,"Ethiopia 2019","Burkina Faso 2021") | occupation != "Ag HH", msymbol(i) mlabel(purchperc) mlabposition(9) mlabformat(%9.0f) mlabcolor(midblue*1.5) mlabsize(5pt)  mlabgap(0pt) || ///
	scatter cntry_occmsr_enc ll_DDS_hlthy_purch if inlist(country,"Ethiopia 2019","Burkina Faso 2021") & occupation == "Ag HH", msymbol(i) mlabel(purchperc) mlabposition(3) mlabformat(%9.0f) mlabcolor(midblue*1.5) mlabsize(5pt)  mlabgap(0pt) || ///
	scatter cntry_occmsr_enc DDS_hlthy_own, mcolor(sienna) msize(vsmall) msymbol(o) || ///
	scatter cntry_occmsr_enc zero, msymbol(i) mlabel(cntry_occmsr) mlabsize(5pt) mlabcolor(black) mlabposition(9) || ///
	scatter cntry_occmsr_enc ll_DDS_hlthy_own if inlist(country,"Ethiopia 2019","Burkina Faso 2021","Guinea-Bissau 2021","Bhutan 2012") & occupation == "Ag HH", msymbol(i) mlabel(ownperc) mlabposition(9) mlabformat(%9.0f) mlabcolor(sienna) mlabsize(5pt)  mlabgap(0pt) || ///
	, xsize(18cm) ysize(22.0cm) yscale(reverse noline)  ylabel(none) ytick(none) xscale(range(-2 8)) xlabel(0(2)8, labsize(5pt)) plotregion(margin(r+2.5 b-1 t-4)) graphregion(margin(l-2 b-4) color(white)) ///
	legend(region(lstyle(none))  size(7pt) rows(1) position(6) bmargin(l-15 r-3) bexpand placement(8) symysize(2)  symxsize(3) ///
	order(2 "HDDS from purchases" "{it:(number is % from tot. HDDS)}" 3 "HDDS not" "purchased" 10 "HDDS from own consumption" "{it:(number is % from tot. HDDS)}" )) ///
	ytitle("") xtitle("Healthy HDDS (0-9)", size(8pt)) 
graph export "${workdir}/graphs/DD_country_occup2.png", replace
graph export "${workdir}/graphs/DD_country_occup2.pdf", replace


*** Fig. 4 
capture drop _dummy z0
gen byte _dummy = 1
label define D 1 " "
label values _dummy D
gen byte z0 = 0

* labels-only strip (no ramp, no tiles)
graph set window fontface "Helvetica"

heatplot z0 country _dummy, discrete cuts(0 1) ///
    colors(white white) legend(off) ///
    yscale(reverse noline) xscale(noline) ///
    ylabel(, valuelabel angle(0) labsize(10pt)) xlabel(none) ///
    ytitle("") xtitle("") ///
    plotregion(margin(0 0 3 11)) graphregion(color(white) margin(0 0 0 0)) ///
    name(H_labels, replace) ysize(5) xsize(1) fxsize(12) fysize(115) nodraw

heatplot purch_perc country occupation,  ///
    discrete colors(white blue) ramp(top title("Share from purchases (in %)", size(10pt)) subtitle("") graphregion(color(white)) space(8) length(15) labels(,labsize(8pt))) ///
    cuts(0(10)100) yscale(reverse noline) xscale(noline) plotregion(margin(0 0 0 -5)) graphregion(color(white)) ///
    ylabel(none) xlabel(, noticks angle(0) labsize(9pt)) ytitle("") xtitle("") values(format(%9.0f) size(7pt))  ///
    name(H_purchshr, replace) ysize(5) xsize(4) missing(label("Missing") color(gs14)) nodraw
	
heatplot own_perc country occupation,  ///
    discrete colors(white sienna) ramp(top title("Share from own production (in %)", size(10pt)) subtitle("") graphregion(color(white)) space(8) length(15) labels(,labsize(8pt))) /// 
    cuts(0(10)100) yscale(reverse noline) xscale(noline) plotregion(margin(0 0 0 -5)) graphregion(color(white)) ///
    ylabel(none) xlabel(, noticks angle(0) labsize(9pt)) ytitle("") xtitle("") values(format(%9.0f) size(7pt)) ///
    name(H_ownshr, replace) ysize(5) xsize(4) missing(label("Missing") color(gs14)) nodraw
	
heatplot gifts_perc country occupation,  ///
    discrete colors(white gold)  ramp(top title("Share from gifts/in-kind (in %)", size(10pt)) subtitle("") graphregion(color(white)) space(8) length(15) labels(,labsize(8pt))) ///
    cuts(0(10)100) yscale(reverse noline) xscale(noline) plotregion(margin(0 0 0 -5)) graphregion(color(white)) ///
    ylabel(none) xlabel(, noticks angle(0) labsize(9pt)) ytitle("") xtitle("") values(format(%9.0f) size(7pt))  ///
    name(H_inkindshr, replace) ysize(5) xsize(4) missing(label("Missing") color(gs14)) nodraw
	
heatplot DDS_hlthy country occupation,  ///
    discrete colors(white green) ramp(top title("HDDS (0-9)", size(10pt)) subtitle("") graphregion(color(white)) space(8) length(15) labels(,labsize(8pt))) ///
    cuts(0(1)9) yscale(reverse noline) xscale(noline) plotregion(margin(0 0 0 -5)) graphregion(color(white)) ///
    ylabel(none) xlabel(, noticks angle(0) labsize(9pt)) ytitle("") xtitle("") values(format(%9.1f) size(7pt)) ///
    name(H_consshr, replace) ysize(5) xsize(4) missing(label("Missing") color(gs14)) nodraw
	

graph combine H_labels H_consshr H_purchshr H_ownshr H_inkindshr, cols(5) xcommon ycommon ///
    imargin(zero) graphregion(color(white) margin(l+7)) ysize(21.0cm) xsize(18cm)
graph export "${workdir}/graphs/DD_country_occup_heatmap.pdf", as(pdf) fontface("Helvetica") replace
graph export "${workdir}/graphs/DD_country_occup_heatmap.png", replace	
	
	

/*******************************************************************************
Replication file for
- Fig. S12 | Country-level dietary diversity and sourcing by household
  own-consumption status.
*******************************************************************************/

use "${datadir}/graphs and tables/DD_bycountry_anyown.dta", clear

decode anyown, gen(occupation)
gen cntry_occmsr = country + " - " + occupation
encode cntry_occmsr, gen(cntry_occmsr_enc)

gen double _pairy = cntry_occmsr_enc + 0.5 if mod(cntry_occmsr_enc, 2) == 1
gen zero = 0
gen _xlo = -4.5
gen _xhi = 8.5
gen pair = ceil(cntry_occmsr_enc / 2)
bysort pair: egen yctr = mean(cntry_occmsr_enc)
gen oddpair = mod(pair, 2) == 1

twoway ///
    (rbar _xlo _xhi cntry_occmsr_enc if oddpair, horizontal barw(1.0) color(gs14) lcolor(none)) || ///
    (rbar zero DDS_hlthy_purch cntry_occmsr_enc, horizontal barw(0.7) color(midblue*0.5)) || ///
    (rbar DDS_hlthy_purch DDS_hlthy cntry_occmsr_enc, horizontal barw(0.7) color(midgreen*0.5)) || ///
    (rspike ll_DDS_hlthy_own ul_DDS_hlthy_own cntry_occmsr_enc, horizontal lcolor(sienna*0.8) lwidth(vthin)) || ///
    (rspike ll_DDS_hlthy_purch ul_DDS_hlthy_purch cntry_occmsr_enc, horizontal lcolor(midblue*0.8) lwidth(vthin)) || ///
    (rspike ll_DDS_hlthy ul_DDS_hlthy cntry_occmsr_enc, horizontal lcolor(midgreen*0.8) lwidth(vthin)) || ///
    (scatter cntry_occmsr_enc ll_DDS_hlthy_own, msymbol(i) mlabel(ownperc) mlabposition(9) mlabformat(%9.0f) mlabcolor(sienna) mlabsize(5pt) mlabgap(0pt)) || ///
    (scatter cntry_occmsr_enc ll_DDS_hlthy_purch if !inlist(country,"Angola 2018","Ethiopia 2019","Burkina Faso 2021","Bhutan 2012") | occupation != "AnyOwnCons", msymbol(i) mlabel(purchperc) mlabposition(9) mlabformat(%9.0f) mlabcolor(midblue*1.5) mlabsize(5pt) mlabgap(0pt)) || ///
    (scatter cntry_occmsr_enc ul_DDS_hlthy_purch if inlist(country,"Angola 2018","Ethiopia 2019","Burkina Faso 2021","Bhutan 2012") & occupation == "AnyOwnCons", msymbol(i) mlabel(purchperc) mlabposition(3) mlabformat(%9.0f) mlabcolor(midblue*1.5) mlabsize(5pt) mlabgap(0pt)) || ///
    (scatter cntry_occmsr_enc DDS_hlthy_own, mcolor(sienna) msize(vsmall) msymbol(o)) || ///
    (scatter cntry_occmsr_enc zero, msymbol(i) mlabel(cntry_occmsr) mlabsize(5pt) mlabcolor(black) mlabposition(9)), ///
    xsize(18cm) ysize(22cm) yscale(reverse noline) ylabel(none) ytick(none) ///
    xscale(range(-2 8)) xlabel(0(2)8, labsize(5pt)) ///
    plotregion(margin(r+2.5 b-1 t-4)) graphregion(margin(l-2 b-4) color(white)) ///
    legend(region(lstyle(none)) size(7pt) rows(1) position(6) ///
        bmargin(l-15 r-3) bexpand placement(8) symysize(2) symxsize(3) ///
        order(2 "HDDS from purchases" "{it:(number is % from tot. HDDS)}" ///
              3 "HDDS not" "purchased" ///
              10 "HDDS from own consumption" "{it:(number is % from tot. HDDS)}")) ///
    ytitle("") xtitle("Healthy HDDS (0-9)", size(8pt))

graph export "${workdir}/graphs/Figure_S12.png", replace
graph export "${workdir}/graphs/Figure_S12.pdf", replace

/*
Sample sizes: N = 1,175,967 for total consumption, purchases, and own
consumption and N = 845,126 for gifts/in-kind.
*/

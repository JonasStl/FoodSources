/*******************************************************************************
Replication file for
- Fig. S2 | Food-sourcing patterns and economic structure.
*******************************************************************************/

do "${workdir}/do/_prepare_table1_wdi.do"

gen double ln_ny_gdp_pcap_pp_kd = ln(ny_gdp_pcap_pp_kd)
label variable ln_ny_gdp_pcap_pp_kd ///
    "Log GDP per capita, PPP (constant 2021 international $)"

* Panel a: GDP per capita.
twoway ///
    (qfitci onlypurch ln_ny_gdp_pcap_pp_kd, ciplot(rline) ///
        clcolor("0 114 178") clpattern(dash) clwidth(vthin) ///
        lcolor("0 114 178") lpattern(solid) lwidth(medthin)) ///
    (qfitci anyown ln_ny_gdp_pcap_pp_kd, ciplot(rline) ///
        clcolor(sienna) clpattern(dash) clwidth(vthin) ///
        lcolor(sienna) lpattern(solid) lwidth(medthin)) ///
    (scatter onlypurch ln_ny_gdp_pcap_pp_kd, ///
        mcolor("0 114 178%80") msymbol(O) msize(medsmall) ///
        mlabel(isocode) mlabsize(tiny) mlabcolor("0 114 178") mlabposition(12)) ///
    (scatter anyown ln_ny_gdp_pcap_pp_kd, ///
        mcolor(sienna%80) msymbol(D) msize(medsmall) ///
        mlabel(isocode) mlabsize(tiny) mlabcolor(sienna) mlabposition(6)), ///
    xtitle("GDP per capita, 2021 PPP (natural log)", size(7pt)) ///
    ytitle("Households (%)", size(7pt)) ///
    xlabel(7(0.5)10.5, labsize(7pt) grid format(%3.1f)) ///
    ylabel(0(20)100, labsize(7pt) grid angle(horizontal)) ///
    xscale(range(7 10.5)) yscale(range(0 100)) ///
    legend(order(5 "Exclusively purchasing food items" 6 "Any own consumption") ///
           cols(2) size(6pt) region(lcolor(none)) ring(1) position(6)) ///
    graphregion(color(white)) plotregion(color(white) lcolor(gs12)) ///
    scheme(s1color) xsize(8.2cm) ysize(7cm) ///
    subtitle("{bf:a}", size(10pt) position(11) span) ///
    name(S2a, replace) nodraw

* Panel b: agriculture value added.
twoway ///
    (qfitci onlypurch nv_agr_totl_zs, ciplot(rline) ///
        clcolor("0 114 178") clpattern(dash) clwidth(vthin) ///
        lcolor("0 114 178") lpattern(solid) lwidth(medthin)) ///
    (qfitci anyown nv_agr_totl_zs, ciplot(rline) ///
        clcolor(sienna) clpattern(dash) clwidth(vthin) ///
        lcolor(sienna) lpattern(solid) lwidth(medthin)) ///
    (scatter onlypurch nv_agr_totl_zs, ///
        mcolor("0 114 178%80") msymbol(O) msize(medsmall) ///
        mlabel(isocode) mlabsize(tiny) mlabcolor("0 114 178") mlabposition(12)) ///
    (scatter anyown nv_agr_totl_zs, ///
        mcolor(sienna%80) msymbol(D) msize(medsmall) ///
        mlabel(isocode) mlabsize(tiny) mlabcolor(sienna) mlabposition(6)), ///
    xtitle("Agriculture value added (% of GDP)", size(7pt)) ///
    ytitle("Households (%)", size(7pt)) ///
    xlabel(0(10)40, labsize(7pt) grid) ///
    ylabel(0(20)100, labsize(7pt) grid angle(horizontal)) ///
    xscale(range(0 42)) yscale(range(0 100)) ///
    legend(order(5 "Exclusively purchasing food items" 6 "Any own consumption") ///
           cols(2) size(6pt) region(lcolor(none)) ring(1) position(6)) ///
    graphregion(color(white)) plotregion(color(white) lcolor(gs12)) ///
    scheme(s1color) xsize(8.2cm) ysize(7cm) ///
    subtitle("{bf:b}", size(10pt) position(11) span) ///
    name(S2b, replace) nodraw

* Panel c: employment in agriculture.
twoway ///
    (qfitci onlypurch sl_agr_empl_zs, ciplot(rline) ///
        clcolor("0 114 178") clpattern(dash) clwidth(vthin) ///
        lcolor("0 114 178") lpattern(solid) lwidth(medthin)) ///
    (qfitci anyown sl_agr_empl_zs, ciplot(rline) ///
        clcolor(sienna) clpattern(dash) clwidth(vthin) ///
        lcolor(sienna) lpattern(solid) lwidth(medthin)) ///
    (scatter onlypurch sl_agr_empl_zs, ///
        mcolor("0 114 178%80") msymbol(O) msize(medsmall) ///
        mlabel(isocode) mlabsize(tiny) mlabcolor("0 114 178") mlabposition(12)) ///
    (scatter anyown sl_agr_empl_zs, ///
        mcolor(sienna%80) msymbol(D) msize(medsmall) ///
        mlabel(isocode) mlabsize(tiny) mlabcolor(sienna) mlabposition(6)), ///
    xtitle("Employment in agriculture (% of total employment)", size(7pt)) ///
    ytitle("Households (%)", size(7pt)) ///
    xlabel(0(20)80, labsize(7pt) grid) ///
    ylabel(0(20)100, labsize(7pt) grid angle(horizontal)) ///
    xscale(range(0 80)) yscale(range(0 100)) ///
    legend(order(5 "Exclusively purchasing food items" 6 "Any own consumption") ///
           cols(2) size(6pt) region(lcolor(none)) ring(1) position(6)) ///
    graphregion(color(white)) plotregion(color(white) lcolor(gs12)) ///
    scheme(s1color) xsize(8.2cm) ysize(7cm) ///
    subtitle("{bf:c}", size(10pt) position(11) span) ///
    name(S2c, replace) nodraw

* Panel d: urban population share.
twoway ///
    (qfitci onlypurch sp_urb_totl_in_zs, ciplot(rline) ///
        clcolor("0 114 178") clpattern(dash) clwidth(vthin) ///
        lcolor("0 114 178") lpattern(solid) lwidth(medthin)) ///
    (qfitci anyown sp_urb_totl_in_zs, ciplot(rline) ///
        clcolor(sienna) clpattern(dash) clwidth(vthin) ///
        lcolor(sienna) lpattern(solid) lwidth(medthin)) ///
    (scatter onlypurch sp_urb_totl_in_zs, ///
        mcolor("0 114 178%80") msymbol(O) msize(medsmall) ///
        mlabel(isocode) mlabsize(tiny) mlabcolor("0 114 178") mlabposition(12)) ///
    (scatter anyown sp_urb_totl_in_zs, ///
        mcolor(sienna%80) msymbol(D) msize(medsmall) ///
        mlabel(isocode) mlabsize(tiny) mlabcolor(sienna) mlabposition(6)), ///
    xtitle("Urban population (% of total population)", size(7pt)) ///
    ytitle("Households (%)", size(7pt)) ///
    xlabel(0(20)100, labsize(7pt) grid) ///
    ylabel(0(20)100, labsize(7pt) grid angle(horizontal)) ///
    xscale(range(0 100)) yscale(range(0 100)) ///
    legend(order(5 "Exclusively purchasing food items" 6 "Any own consumption") ///
           cols(2) size(6pt) region(lcolor(none)) ring(1) position(6)) ///
    graphregion(color(white)) plotregion(color(white) lcolor(gs12)) ///
    scheme(s1color) xsize(8.2cm) ysize(7cm) ///
    subtitle("{bf:d}", size(10pt) position(11) span) ///
    name(S2d, replace) nodraw

graph combine S2a S2b S2c S2d, cols(2) graphregion(color(white)) ///
    imargin(tiny) xsize(16.4cm) ysize(14cm)
graph export "${workdir}/graphs/Figure_S2.png", replace width(3600)
graph export "${workdir}/graphs/Figure_S2.pdf", replace

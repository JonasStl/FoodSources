/*******************************************************************************
Replication File for
- Fig. S14 | Food sources using food group categories based on the HDDS versus the MDD-W.
*******************************************************************************/

use "$datadir/graphs and tables/DD_country.dta", clear
drop if inlist(country,"Tajikistan 2009","Jamaica 2019","El Salvador 2014","Namibia 2015")

gen diversitymsr = "HDDS"


append using "$datadir/graphs and tables/MDDW_country.dta"
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


* Fig. S14:

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
graph export "$workdir/graphs/Figure_S14.png", replace
graph export "$workdir/graphs/Figure_S14.pdf", replace


/*
Figure Notes:

Fig. S14 | Food sources using food group categories based on the HDDS versus the MDD-W.
For each country, two rows are shown: the Healthy Household Dietary Diversity Score (HDDS) (scale 0–9) and Minimum Dietary Diversity for Women (MDDW) score (scale 0–10). Note that the MDDW is also constructed at the household-level here, as is the HDDS.

The horizontal bar length is the mean score. The blue segment is the share of the score attributable to items obtained through purchases; the green segment is the additional share obtained only from non-purchase sources. Thus, blue + green = total diversity.
Brown dots mark the dietary diversity from own production and numbers indicate the proportion from total diversity for that row. Estimates are computed with population-adjusted survey weights and represent country averages. Country labels indicate the survey year and the indicator (HDDS or MDDW).
Sample size: N = 1,150,168 households.

*/

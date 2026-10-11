/*******************************************************************************
Replication File for
- Fig. 3 | Healthy household dietary diversity (9 food groups) by country.
- Fig. S13 | Relationship between total healthy dietary diversity (HDDS) and proportions from purchases and own consumption. 
*******************************************************************************/
use "$datadir/graphs and tables/DD_country.dta", clear

quietly summarize _country, meanonly
local max_country = r(max)

gen zero = 0

sum purch_perc if DDS_hlthy <= 6
sum purch_perc if DDS_hlthy > 6
/*
In countries with HDDS of 6 or lower, purchases cover 81% of the diversity, on average.
In countries with HDDS of higher than 6, purchases cover 89% of the diversity, on average.
*/
sum own_perc if DDS_hlthy <= 6
sum own_perc if DDS_hlthy > 6
/*
In countries with HDDS of 6 or lower, own consumption cover 24% of the diversity, on average.
In countries with HDDS of higher than 6, own consumption cover 16% of the diversity, on average.
*/


* Figure 3:
graph set window fontface "Helvetica"
twoway rbar zero DDS_hlthy_purch _country, horizontal barw(0.7) color(midblue*0.5) || ///
	rbar DDS_hlthy_purch DDS_hlthy _country, horizontal barw(0.7) color(midgreen*0.5)  || ///
	rcap ll_DDS_hlthy ul_DDS_hlthy _country, horizontal lwidth(vthin) color(midgreen*0.8) || ///
	rcap ll_DDS_hlthy_purch ul_DDS_hlthy_purch _country, horizontal lwidth(vthin) color(blue*0.8)  || ///
	rcap ll_DDS_hlthy_own ul_DDS_hlthy_own _country, horizontal lwidth(vthin) color(sienna*0.8)  || ///
	scatter _country ul_DDS_hlthy, msymbol(i) mlabel(DDS_hlthy) mlabposition(3) mlabformat(%9.1f) mlabcolor(midgreen) mlabsize(7pt) || ///
	scatter _country ul_DDS_hlthy_own, msymbol(i) mlabel(ownperc) mlabposition(3) mlabformat(%9.0f) mlabcolor(sienna) mlabsize(7pt) mlabgap(1pt) || ///
	scatter _country ll_DDS_hlthy_purch, msymbol(i) mlabel(purchperc) mlabposition(9) mlabformat(%9.0f) mlabcolor(midblue*1.5) mlabsize(7pt) mlabgap(1pt) || ///
	scatter _country DDS_hlthy_own, mcolor(sienna) msize(small) msymbol(o) || ///
	, xsize(18cm) ysize(21.5cm) ylabel(1(1)`max_country',valuelabel angle(0) labsize(7pt) nogrid) xlabel(, labsize(7pt)) plotregion(margin(r+2.5)) graphregion(margin(l+20 b-5 t-3) color(white)) ///
	legend(region(lstyle(none)) size(7pt) rows(1) position(7) bmargin(l-15 r-3) bexpand placement(8)  symysize(2)  symxsize(3) ///
	order(2 "HDDS not" "purchased" 1 "HDDS from purchases" "{it:(number is % from tot. HDDS)}" 9 "HDDS from own consumption" "{it:(number is % from tot. HDDS)}")) ///
	xline(8, lcolor(gs15)) xline(7, lcolor(gs15)) xline(6, lcolor(gs15)) xline(5, lcolor(gs15)) xline(4, lcolor(gs15)) xline(3, lcolor(gs15)) xline(2, lcolor(gs15)) xline(1, lcolor(gs15)) ///
	ytitle("") xtitle("Healthy HDDS (0-9)", size(7pt)) 
graph export "$workdir/graphs/Figure_3.png", replace	
graph export "$workdir/graphs/Figure_3.pdf", replace

/*
Figure Notes: 

Figure 3: Healthy household dietary diversity (9 food groups) by country.
Blue horizontal bars represent the share of total HDDS obtained from purchases. The green segment is the additional HDDS met from non-purchase sources (own production and gifts/in-kind). Blue + green equals the country mean HDDS indicated by the green number. The blue percentages on bars report the share of HDDS from purchases; brown dots (with brown percentages) show the share from own production. 95% confidence intervals are shown for dietary diversity from own production, purchases, and total HDDS. Countries are ordered from top to bottom by their average household consumption expenditure in the survey year, using the World Bank Poverty and Inequality Platform (PIP). For Tokelau and the Cook Islands, where PIP data is not available, ordering uses the survey's own mean consumption. Sample size: N = 1,175,967 households.
*/


* Fig. S13: Do countries with higher HDDS have more consumption from purchases and less from own consumption?
twoway  (qfitci purch_perc DDS_hlthy, lcolor(midblue) lpattern(solid) acolor(gs14)) || ///
	(qfitci own_perc DDS_hlthy, lcolor(sienna) lpattern(solid) acolor(gs14)) || ///
	(scatter purch_perc own_perc DDS_hlthy, mlabel(_country _country) msize(vsmall vsmall) mlabsize(7pt 7pt) mcolor(midblue sienna) mlabcolor(midblue sienna) mlabposition(12)), ///
	xtitle("Healthy HDDS", size(7pt)) ytitle("Share of total HDDS (in %)", size(7pt)) ylabel(,angle(0) labsize(7pt)) xlabel(,labsize(7pt)) legend(size(7pt) ring(0) position(3) rows(2) order(2 "From purchases" 4 "From own consumption")) graphregion(color(white) margin(r+2)) xsize(18.0cm) ysize(13.0cm)
graph export "$workdir/graphs/Figure_S13.png", replace
graph export "$workdir/graphs/Figure_S13.pdf", replace

/*
Figure Notes: 

Fig. S13 | Relationship between total healthy dietary diversity (HDDS) and proportions from purchases and own consumption. 
Each marker is a survey-weighted population-adjusted design-corrected country mean. The x-axis is the mean healthy HDDS (0–9 food groups). The y-axis is the percentage of total HDDS that is met by the indicated source. Blue refers to purchases and brown to own production. The lines indicate quadratic fits and the grey bands are 95% confidence intervals for those smooths.
*/

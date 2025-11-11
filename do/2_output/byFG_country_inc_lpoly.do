/*******************************************************************************
Replication File for
- Extended Data Fig. 2 | Relationship between consumption of nine food groups and household expenditure by country. 
*******************************************************************************/
use "${datadir}/graphs and tables/byFG_inc_lpoly.dta", clear

gen insample = (HDDS_1 < . & psu < . & wgt < . & exp_ae_w_ln <.)
bysort surveyid: egen double all_obs = sum(w_new) if w_new != . & insample == 1
gen wgt_new = .
replace wgt_new = w_new*totpop/all_obs


egen countryyear = concat(country year), punct(" ")
encode countryyear, gen(country_enc)

* Extended Data Fig. 2 | Relationship between consumption of nine food groups and household expenditure by country. 
graph set window fontface "Helvetica"

// set upper values for Barbados equal to missing and drop Tokelau due to large confidence intervals
gstats winsor exp_ae_w_ln if country == "Barbados", by(surveyid) cut(5 95) trim 
replace exp_ae_w_ln = exp_ae_w_ln_tr if country == "Barbados"
drop exp_ae_w_ln_tr

drop if country == "Tokelau"


twoway (lpolyci HDDS_1 exp_ae_w_ln [aw=wgt_new], clcolor(sienna) acolor(sienna*0.4%50)) ///
	(lpolyci HDDS_2 exp_ae_w_ln [aw=wgt_new], clcolor(orange) acolor(orange*0.4%50)) ///
	(lpolyci HDDS_3 exp_ae_w_ln [aw=wgt_new], clcolor(lavender) acolor(lavender*0.4%50)) ///
	(lpolyci HDDS_5 exp_ae_w_ln [aw=wgt_new], clcolor(midblue*1.2) acolor(midblue*0.4%50)) ///
	(lpolyci HDDS_5 exp_ae_w_ln [aw=wgt_new], clcolor(midgreen) acolor(midgreen*0.4%50)) ///
	(lpolyci HDDS_6 exp_ae_w_ln [aw=wgt_new], clcolor(cranberry) acolor(cranberry*0.4%50)) ///
	(lpolyci HDDS_7 exp_ae_w_ln [aw=wgt_new], clcolor(ebblue) acolor(ebblue*0.4%50)) ///
	(lpolyci HDDS_8 exp_ae_w_ln [aw=wgt_new], clcolor(gray) acolor(gray*0.4%50)) ///
	(lpolyci HDDS_9 exp_ae_w_ln [aw=wgt_new], clcolor(gold) acolor(gold*0.4%50)) ///
	, by(country_enc, cols(4) note("") graphregion(color(white)) imargin(tiny)) subtitle(,size(13pt) bcolor(gs15)) xsize(18.0cm) ysize(22.0cm) graphregion(color(white) margin(t-7 b-10)) ytitle("Consumption (% of HHs)", size(7pt)) xtitle("Log. exp. per adult-eq. per day in USD (2021 PPPs)", size(7pt)) xlab(, labsize(12pt)) ylab(0(20)100, angle(0) labsize(12pt)) ytick(0(20)100, grid) yscale(range(0 100)) ///
	legend(region(lstyle(none)) symysize(2) symxsize(4) size(6pt) rows(2) order(2 "Cereals" 4 "Roots, tubers," "and plantains" 6 "Pulses, nuts" "and seeds" 8 "Vegetables"  ///
	 10 "Fruits" 12 "Meat"  14 "Fish and seafood" 16 "Milk and" "dairy products" 18 "Eggs"))
graph export "${workdir}/graphs/FG_country_inc_lpoly.png", replace
graph export "${workdir}/graphs/FG_country_inc_lpoly.pdf", replace

/*******************************************************************************
Replication File for
- Fig. S20 | Source-specific food item diversity and consumption expenditure by country. 
*******************************************************************************/
use "${datadir}/graphs and tables/items_country_inc_lpoly.dta", clear

// reweight
gen insample = (HDDS_1 < . & psu < . & wgt < . & exp_ae_w_ln <.)
bysort surveyid: egen double all_obs = sum(w_new) if w_new != . & insample == 1
gen wgt_new = .
replace wgt_new = w_new*totpop/all_obs


egen Ncons_hlthy = rowtotal(HDDS_1_Ncons HDDS_2_Ncons HDDS_3_Ncons HDDS_4_Ncons HDDS_5_Ncons HDDS_6_Ncons HDDS_7_Ncons HDDS_8_Ncons HDDS_9_Ncons), missing
egen Ncons_purch = rowtotal(HDDS_1_Ncons_purch HDDS_2_Ncons_purch HDDS_3_Ncons_purch HDDS_4_Ncons_purch HDDS_5_Ncons_purch HDDS_6_Ncons_purch HDDS_7_Ncons_purch HDDS_8_Ncons_purch HDDS_9_Ncons_purch), missing
egen Ncons_own = rowtotal(HDDS_1_Ncons_own HDDS_2_Ncons_own HDDS_3_Ncons_own HDDS_4_Ncons_own HDDS_5_Ncons_own HDDS_6_Ncons_own HDDS_7_Ncons_own HDDS_8_Ncons_own HDDS_9_Ncons_own), missing
egen Ncons_rec = rowtotal(HDDS_1_Ncons_rec HDDS_2_Ncons_rec HDDS_3_Ncons_rec HDDS_4_Ncons_rec HDDS_5_Ncons_rec HDDS_6_Ncons_rec HDDS_7_Ncons_rec HDDS_8_Ncons_rec HDDS_9_Ncons_rec), missing

gen Ncons_purch_shr = (Ncons_purch/Ncons_hlthy)*100
gen Ncons_own_shr = (Ncons_own/Ncons_hlthy)*100
gen Ncons_rec_shr = (Ncons_rec/Ncons_hlthy)*100

* Fig. S20 
twoway (lpolyci Ncons_purch_shr exp_ae_w_ln [aw=wgt_new], clcolor(midblue) acolor(midblue*0.4)) ///
	(lpolyci Ncons_own_shr exp_ae_w_ln [aw=wgt_new], clcolor(sienna) acolor(sienna*0.4)) ///
	(lpolyci Ncons_rec_shr exp_ae_w_ln [aw=wgt_new], clcolor(gold) acolor(gold*0.4)) ///
	, by(country, cols(4) note("") graphregion(color(white)) imargin(tiny)) subtitle(,size(12pt) bcolor(gs15)) xsize(18cm) ysize(21cm) graphregion(color(white) margin(b-3)) ytitle("Share of food items consumed from each source", size(8pt))  xtitle("Log. exp. per day per adult-eq. in USD (2021 PPPs)", size(8pt)) ytick(0(20)100, grid) ylab(0(20)100, angle(0) labsize(10pt)) xlab(,labsize(10pt)) yscale(range(0 100)) ///
	legend(region(lstyle(none)) symxsize(3) symysize(2) size(7pt) rows(1) order(1 "HDDS from purchases" "with 95% CIs" 3 "HDDS from own" "consumption with 95% CIs" 5 "HDDS from gifts/" "in-kind with 95% CIs"))

graph export "${workdir}/graphs/items_country_inc_lpoly.png", replace
graph export "${workdir}/graphs/items_country_inc_lpoly.pdf", replace

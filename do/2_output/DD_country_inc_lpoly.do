/*******************************************************************************
Replication File for
- Extended Data Fig. 3 | Dietary diversity and consumption expenditure, by country and source. 
*******************************************************************************/
use "${datadir}/graphs and tables/DD_country_inc_lpoly.dta", clear

gen insample = (HDDS_1 < . & psu < . & wgt < . & exp_ae_w_ln <.)
bysort surveyid: egen double all_obs = sum(w_new) if w_new != . & insample == 1
gen wgt_new = .
replace wgt_new = w_new*totpop/all_obs

* Globally (not included)
twoway (lpolyci DDS_hlthy exp_ae_w_ln [aw=wgt_new], clcolor(midgreen) acolor(midgreen*0.4)) ///
	(lpolyci DDS_hlthy_purch exp_ae_w_ln [aw=wgt_new], clcolor(midblue) acolor(midblue*0.4)) ///
	(lpolyci DDS_hlthy_own exp_ae_w_ln [aw=wgt_new], clcolor(sienna) acolor(sienna*0.4)) ///
	(lpolyci DDS_hlthy_rec exp_ae_w_ln [aw=wgt_new], clcolor(gold) acolor(gold*0.4)) ///
	,  graphregion(color(white)) xtitle("Log. exp. per day per adult-eq. in USD (2021 PPPs)", size(5pt)) ylab(0(1)9, angle(0)) yscale(range(0 9)) ytitle("Healthy HDDS (0-9)", size(5pt)) legend(region(lstyle(none)) symxsize(3) symysize(2) size(5pt) rows(2) order(1 "Total HDDS with 95% CIs" 3 "HDDS from purchases with 95% CIs" 5 "HDDS from own consumption with 95% CIs" 7 "HDDS from gifts/in-kind with 95% CIs")) xsize(8.8cm) ysize(6cm) 
graph export "${workdir}/graphs/DD_global_inc_lpoly.png", replace


* Extended Data Fig. 3:
twoway (lpolyci DDS_hlthy_purch exp_ae_w_ln [aw=wgt_new], clcolor(midblue) acolor(midblue*0.4)) ///
	(lpolyci DDS_hlthy exp_ae_w_ln [aw=wgt_new], clcolor(midgreen) acolor(midgreen*0.4)) ///
	(lpolyci DDS_hlthy_own exp_ae_w_ln [aw=wgt_new], clcolor(sienna) acolor(sienna*0.4)) ///
	(lpolyci DDS_hlthy_rec exp_ae_w_ln [aw=wgt_new], clcolor(gold) acolor(gold*0.4)) ///
	, by(country, cols(4) note("") graphregion(color(white)) /*legend(at(38) pos(3) bmargin(r+30))*/ imargin(tiny)) subtitle(,size(12pt) bcolor(gs15)) xsize(18cm) ysize(21cm) graphregion(color(white) margin(t-5 b-10)) ytitle("Healthy HDDS", size(8pt))  xtitle("Log. exp. per day per adult-eq. in USD (2021 PPPs)", size(8pt)) ytick(0(2)9, grid) ylab(0(2)9, angle(0) labsize(12pt)) xlab(,labsize(12pt)) yscale(range(0 9)) ///
	legend(region(lstyle(none)) symxsize(3) symysize(2) size(6pt) rows(2) order(3 "Total HDDS with 95% CIs" 1 "HDDS from purchases with 95% CIs" 5 "HDDS from own consumption with 95% CIs" 7 "HDDS from gifts/in-kind with 95% CIs"))
graph export "${workdir}/graphs/DD_country_inc_lpoly.png", replace
graph export "${workdir}/graphs/DD_country_inc_lpoly.pdf", replace

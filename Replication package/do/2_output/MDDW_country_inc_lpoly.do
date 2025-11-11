/*******************************************************************************
Replication File for
- Fig. S21 | MDDW and consumption expenditure, by country and source. 
*******************************************************************************/
use "${datadir}/graphs and tables/MDDW_country_inc_lpoly.dta", clear

gen insample = (HDDS_1 < . & psu < . & wgt < . & exp_ae_w_ln <.)
bysort surveyid: egen double all_obs = sum(w_new) if w_new != . & insample == 1
gen wgt_new = .
replace wgt_new = w_new*totpop/all_obs

* Fig. S21 | MDDW and consumption expenditure, by country and source. 
twoway (lpolyci MDDW_purch exp_ae_w_ln [aw=wgt_new], clcolor(midblue) acolor(midblue*0.4)) ///
	(lpolyci MDDW exp_ae_w_ln [aw=wgt_new], clcolor(midgreen) acolor(midgreen*0.4)) ///
	(lpolyci MDDW_own exp_ae_w_ln [aw=wgt_new], clcolor(sienna) acolor(sienna*0.4)) ///
	(lpolyci MDDW_rec exp_ae_w_ln [aw=wgt_new], clcolor(gold) acolor(gold*0.4)) ///
	, by(country, cols(4) note("") graphregion(color(white)) imargin(tiny)) subtitle(,size(12pt) bcolor(gs15)) xsize(18cm) ysize(21cm) graphregion(color(white)  margin(t-5 b-10)) ytitle("MDDW (0-10)", size(8pt))  xtitle("Log. exp. per day per adult-eq. in USD (2021 PPPs)", size(8pt)) ytick(0(2)10, grid) ylab(0(2)10, angle(0) labsize(12pt)) xlab(,labsize(12pt)) yscale(range(0 9)) ///
	legend(region(lstyle(none)) symxsize(3) symysize(2) size(6pt) rows(2) order(3 "Total MDDW with 95% CIs" 1 "MDDW from purchases with 95% CIs" 5 "MDDW from own consumption with 95% CIs" 7 "MDDW from gifts/in-kind with 95% CIs"))
graph export "${workdir}/graphs/MDDW_country_inc_lpoly.png", replace
graph export "${workdir}/graphs/MDDW_country_inc_lpoly.pdf", replace


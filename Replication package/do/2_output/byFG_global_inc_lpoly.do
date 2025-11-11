/*******************************************************************************
Replication File for
- Fig. S5 | Relationship between source-specific consumption of nine food groups and household consumption expenditure. 
*******************************************************************************/
use "${datadir}/graphs and tables/byFG_inc_lpoly_global.dta", clear

gen insample = (HDDS_1 < . & psu < . & wgt < . & exp_ae_w_ln <.)
bysort surveyid: egen double all_obs = sum(w_new) if w_new != . & insample == 1
gen wgt_new = .
replace wgt_new = w_new*totpop/all_obs

* Fig. S5 
graph set window fontface "Helvetica"
foreach v of numlist 1 4 {
	local lbl: var label HDDS_`v' 
	
	twoway (lpolyci HDDS_`v' exp_ae_w_ln [aw=wgt_new], clcolor(midgreen) acolor(midgreen*0.4)) ///
	(lpolyci HDDS_`v'_purch exp_ae_w_ln [aw=wgt_new], clcolor(midblue) acolor(midblue*0.4)) ///
	(lpolyci HDDS_`v'_own exp_ae_w_ln [aw=wgt_new], clcolor(sienna) acolor(sienna*0.4)) ///
	(lpolyci HDDS_`v'_rec exp_ae_w_ln [aw=wgt_new], clcolor(gold) acolor(gold*0.4)) ///
	,  graphregion(color(white)) title("`lbl'", size(9pt)) ytitle("Consumption (% of HHs)", size(7pt)) xtitle("") ytick(0(20)100, grid) ylab(0(20)100, angle(0) labsize(7pt)) yscale(range(0 100)) xlab(,nolab) legend(region(lstyle(none)) size(7pt) rows(2) order(1 "Consumption with 95% CIs" 3 "Consumption from purchases with 95% CIs" 5 "Consumption from own consumption with 95% CIs" 7 "Consumption from gifts/in-kind with 95% CIs")) ///
	nodraw name(g`v', replace) fysize(100) fxsize(115)
}
foreach v of numlist 8 9 {
	local lbl: var label HDDS_`v' 
	
	twoway (lpolyci HDDS_`v' exp_ae_w_ln [aw=wgt_new], clcolor(midgreen) acolor(midgreen*0.4)) ///
	(lpolyci HDDS_`v'_purch exp_ae_w_ln [aw=wgt_new], clcolor(midblue) acolor(midblue*0.4)) ///
	(lpolyci HDDS_`v'_own exp_ae_w_ln [aw=wgt_new], clcolor(sienna) acolor(sienna*0.4)) ///
	(lpolyci HDDS_`v'_rec exp_ae_w_ln [aw=wgt_new], clcolor(gold) acolor(gold*0.4)) ///
	,  graphregion(color(white)) title("`lbl'", size(9pt)) ytitle("") xtitle("Log. exp. per adult-eq. in USD (2021 PPP)", size(7pt)) ytick(0(20)100, grid) ylab(, nolab) yscale(range(0 100)) xlab(,labsize(7pt)) legend(region(lstyle(none)) size(7pt) rows(2) order(1 "Consumption with 95% CIs" 3 "Consumption from purchases with 95% CIs" 5 "Consumption from own consumption with 95% CIs" 7 "Consumption from gifts/in-kind with 95% CIs")) ///
	nodraw name(g`v', replace) fysize(115) fxsize(100)
}
foreach v of numlist 7 {
	local lbl: var label HDDS_`v' 
	
	twoway (lpolyci HDDS_`v' exp_ae_w_ln [aw=wgt_new], clcolor(midgreen) acolor(midgreen*0.4)) ///
	(lpolyci HDDS_`v'_purch exp_ae_w_ln [aw=wgt_new], clcolor(midblue) acolor(midblue*0.4)) ///
	(lpolyci HDDS_`v'_own exp_ae_w_ln [aw=wgt_new], clcolor(sienna) acolor(sienna*0.4)) ///
	(lpolyci HDDS_`v'_rec exp_ae_w_ln [aw=wgt_new], clcolor(gold) acolor(gold*0.4)) ///
	,  graphregion(color(white)) title("`lbl'", size(9pt)) ytitle("Consumption (% of HHs)", size(7pt)) xtitle("Log. exp. per adult-eq. in USD (2021 PPP)", size(7pt)) ytick(0(20)100, grid) ylab(0(20)100, angle(0) labsize(7pt)) yscale(range(0 100)) xlab(,labsize(7pt)) legend(region(lstyle(none)) size(7pt) rows(2) order(1 "Consumption with 95% CIs" 3 "Consumption from purchases with 95% CIs" 5 "Consumption from own consumption with 95% CIs" 7 "Consumption from gifts/in-kind with 95% CIs")) ///
	nodraw name(g`v', replace) fysize(115) fxsize(115)
}
foreach v of numlist 2 3 5 6 {
	local lbl: var label HDDS_`v' 
	
	twoway (lpolyci HDDS_`v' exp_ae_w_ln [aw=wgt_new], clcolor(midgreen) acolor(midgreen*0.4)) ///
	(lpolyci HDDS_`v'_purch exp_ae_w_ln [aw=wgt_new], clcolor(midblue) acolor(midblue*0.4)) ///
	(lpolyci HDDS_`v'_own exp_ae_w_ln [aw=wgt_new], clcolor(sienna) acolor(sienna*0.4)) ///
	(lpolyci HDDS_`v'_rec exp_ae_w_ln [aw=wgt_new], clcolor(gold) acolor(gold*0.4)) ///
	,  graphregion(color(white)) title("`lbl'", size(9pt)) ytitle("") xtitle("", size(7pt)) ytick(0(20)100, grid) ylab(,nolab) yscale(range(0 100)) xlab(,nolab) legend(region(lstyle(none)) size(7pt) rows(2) order(1 "Consumption with 95% CIs" 3 "Consumption from purchases with 95% CIs" 5 "Consumption from own consumption with 95% CIs" 7 "Consumption from gifts/in-kind with 95% CIs")) ///
	nodraw name(g`v', replace) fysize(100) fxsize(100)
}

grc1leg2 g1 g2 g3 g4 g5 g6 g7 g8 g9, rows(3) graphregion(color(white)) imargin(tiny) xsize(18.0cm) ysize(12.0cm)
graph export "${workdir}/graphs/FG_global_inc_lpoly.png", replace
graph export "${workdir}/graphs/FG_global_inc_lpoly.pdf", replace

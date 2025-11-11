/*******************************************************************************
Preparation for 
- Extended Data Fig. 3 | Dietary diversity and consumption expenditure, by country and source. 
*******************************************************************************/

use "${datadir}/processed_analysis.dta", clear
gen exp_ae_w_ln = ln(exp_ae_w)

keep exp_ae_w_ln psu wgt w_new totpop surveyid country HDDS_1 ///
     DDS_hlthy DDS_hlthy_purch DDS_hlthy_own DDS_hlthy_rec

save "$datadir/graphs and tables/DD_country_inc_lpoly.dta", replace

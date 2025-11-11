/*******************************************************************************
Preparation for 
- Fig. S20 | Source-specific food item diversity and consumption expenditure by country. 
*******************************************************************************/

use "${datadir}/processed_analysis.dta", clear
gen exp_ae_w_ln = ln(exp_ae_w)

keep exp_ae_w_ln psu wgt w_new totpop surveyid country HDDS_1 ///
     MDDW MDDW_purch MDDW_own MDDW_rec

save "$datadir/graphs and tables/MDDW_country_inc_lpoly.dta", replace

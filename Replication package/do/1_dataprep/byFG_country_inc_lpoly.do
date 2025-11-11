/*******************************************************************************
Preparation for 
- Extended Data Fig. 2 | Relationship between consumption of nine food groups and household expenditure by country. 
*******************************************************************************/

use "${datadir}/processed_analysis.dta", clear
gen exp_ae_w_ln = ln(exp_ae_w)

keep surveyid psu wgt w_new totpop country year exp_ae_w_ln HDDS_1 HDDS_2 HDDS_3 HDDS_4 HDDS_5 HDDS_6 HDDS_7 HDDS_8 HDDS_9


save "$datadir/graphs and tables/byFG_inc_lpoly.dta", replace

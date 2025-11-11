/*******************************************************************************
Preparation for 
- Fig. S5 | Relationship between source-specific consumption of nine food groups and household consumption expenditure. 
*******************************************************************************/
use "${datadir}/processed_analysis.dta", clear
gen exp_ae_w_ln = ln(exp_ae_w)

keep exp_ae_w_ln psu wgt w_new totpop surveyid ///
     HDDS_1 HDDS_2 HDDS_3 HDDS_4 HDDS_5 HDDS_6 HDDS_7 HDDS_8 HDDS_9 ///
     HDDS_1_purch HDDS_2_purch HDDS_3_purch HDDS_4_purch HDDS_5_purch HDDS_6_purch HDDS_7_purch HDDS_8_purch HDDS_9_purch ///
     HDDS_1_own   HDDS_2_own   HDDS_3_own   HDDS_4_own   HDDS_5_own   HDDS_6_own   HDDS_7_own   HDDS_8_own   HDDS_9_own ///
     HDDS_1_rec   HDDS_2_rec   HDDS_3_rec   HDDS_4_rec   HDDS_5_rec   HDDS_6_rec   HDDS_7_rec   HDDS_8_rec   HDDS_9_rec

save "$datadir/graphs and tables/byFG_inc_lpoly_global.dta", replace

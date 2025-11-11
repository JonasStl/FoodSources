/*******************************************************************************
Preparation for 
- Fig. S20 | Source-specific food item diversity and consumption expenditure by country. 
*******************************************************************************/
use "${datadir}/processed_analysis.dta", clear
gen exp_ae_w_ln = ln(exp_ae_w)


keep exp_ae_w_ln psu wgt w_new totpop surveyid country HDDS_1 ///
    HDDS_1_Ncons  HDDS_2_Ncons  HDDS_3_Ncons  HDDS_4_Ncons  HDDS_5_Ncons ///
    HDDS_6_Ncons  HDDS_7_Ncons  HDDS_8_Ncons  HDDS_9_Ncons ///
    HDDS_1_Ncons_purch HDDS_2_Ncons_purch HDDS_3_Ncons_purch ///
    HDDS_4_Ncons_purch HDDS_5_Ncons_purch HDDS_6_Ncons_purch ///
    HDDS_7_Ncons_purch HDDS_8_Ncons_purch HDDS_9_Ncons_purch ///
    HDDS_1_Ncons_own   HDDS_2_Ncons_own   HDDS_3_Ncons_own ///
    HDDS_4_Ncons_own   HDDS_5_Ncons_own   HDDS_6_Ncons_own ///
    HDDS_7_Ncons_own   HDDS_8_Ncons_own   HDDS_9_Ncons_own ///
    HDDS_1_Ncons_rec   HDDS_2_Ncons_rec   HDDS_3_Ncons_rec ///
    HDDS_4_Ncons_rec   HDDS_5_Ncons_rec   HDDS_6_Ncons_rec ///
    HDDS_7_Ncons_rec   HDDS_8_Ncons_rec   HDDS_9_Ncons_rec

save "$datadir/graphs and tables/items_country_inc_lpoly.dta", replace


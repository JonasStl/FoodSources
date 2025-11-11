/********************************************************************
  *** Title: Food Sourcing and Diets: Evidence from 45 Low- and 
              Middle-Income Countries ***
  * By Jonas Stehl, Kibrom Sibhatu, Lindsay M. Jaacks, Sebastian Vollmer
  * Replication Package: Setup file
  * Correspondence: Jonas Stehl (jonas.stehl@uni-goettingen.de)
  * Date: 10.11.2025
********************************************************************/

clear all
set more off
version 17.0 


* 0_globals: contains all necessary globals to run the files and should be run at the start
global workdir ".../Replication package" // insert folder path // "./Replication package"
global datadir ".../Replication package/data" 

cd "${workdir}"

capture mkdir "${workdir}/graphs"
capture mkdir "${workdir}/tables"

*-----------------------------------------------------------------------
* Install all user-written commands needed for replication
*-----------------------------------------------------------------------

* General packages
capture ssc install wbopendata
capture ssc install gtools
capture ssc install sencode
capture ssc install shp2dta
capture ssc install spmap

capture ssc install fre
capture ssc install estout

* Mapping & graphics packages
capture ssc install palettes, replace
capture ssc install colrspace, replace
capture ssc install heatplot, replace
capture ssc install isocodes, replace


*-----------------------------------------------------------------------
* Run files
*-----------------------------------------------------------------------

* Table 1
do "${workdir}/do/2_output/table1.do"
* Fig. 3, Fig. S12
do "${workdir}/do/2_output/DD_country.do"
* Fig. 1
do "${workdir}/do/2_output/byFG_global.do"
* Fig. 4, Fig. S10 
do "${workdir}/do/2_output/DD_country_byfarm.do"
* Fig. 5
do "${workdir}/do/2_output/DD_global_rururb_hhinc.do"
* Fig. 6, Table S1
do "${workdir}/do/2_output/regression_dds.do"
* Extended Data Fig. 1, Fig. S2
do "${workdir}/do/2_output/byFG_country.do"
* Extended Data Fig. 2
do "${workdir}/do/2_output/byFG_country_inc_lpoly.do"
* Extended Data Fig. 3
do "${workdir}/do/2_output/DD_country_inc_lpoly.do"
* Extended Data Fig. 4, Fig. S19
do "${workdir}/do/2_output/DD_country_rururb_hhinc.do"
* Extended Data Fig. 5
do "${workdir}/do/2_output/regression_dds_incomegroup.do"

* Fig. S1
do "${workdir}/do/2_output/worldmaps.do"
cd "${workdir}"
* Fig. S2
do "${workdir}/do/2_output/byFG_global_povcat.do"
* Fig. S3
do "${workdir}/do/2_output/byFGitem_global.do"
* Fig. S4
do "${workdir}/do/2_output/othersources.do"
* Fig. S5
do "${workdir}/do/2_output/byFG_global_inc_lpoly.do"
* Fig. S6
do "${workdir}/do/2_output/byFG_country_incquintile.do"
* Fig. S7
do "${workdir}/do/2_output/byFG_global_byfarm.do"
* Fig. S8
do "${workdir}/do/2_output/byFG_global_urban.do"
* Fig. S9
do "${workdir}/do/2_output/byFGitem_global_byfarm.do"
* Fig. S11
do "${workdir}/do/2_output/DD_country_anyown.do"
* Fig. S13
do "${workdir}/do/2_output/MDDW_country.do"
* Fig. S14
do "${workdir}/do/2_output/item_country.do"
* Fig. S15
do "${workdir}/do/2_output/DD_time.do"
* Fig. S16, S17, S18
do "${workdir}/do/2_output/seasonality.do"
* Fig. S20
do "${workdir}/do/2_output/items_country_inc_lpoly.do"
* Fig. S21
do "${workdir}/do/2_output/MDDW_country_inc_lpoly.do"
* Fig. S22, Table S2
do "${workdir}/do/2_output/regression_mddw.do"
* Table S3
do "${workdir}/do/2_output/datainfo.do"
* Table S4
do "${workdir}/do/2_output/summarystatistics.do"





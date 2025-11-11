/*******************************************************************************
Preparation for 
- Table S3 | Data Information.
*******************************************************************************/
use "${datadir}/processed_analysis.dta", clear

bysort surveyid: egen samplesize = count(DDS_hlthy)

collapse (firstnm) countrycode survey_name endyear totpop samplesize, by(country strtyear)

save "$datadir/graphs and tables/tableS3.dta", replace

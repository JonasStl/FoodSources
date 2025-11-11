/*******************************************************************************
Replication File for
- Fig. S1 | Sources of food in low- and middle-income countries. 
*******************************************************************************/
cd "${datadir}/aux data/World Bank Official Boundaries - Admin 0"
//shp2dta using WB_GAD_ADM0, database(_worldmap) coordinates(_worldmap_coordinates) replace

use _worldmap.dta, clear
ren NAM_0 country
ren ISO_A3 isocode

replace country = "Dem. Rep. of the Congo" if country == "Congo, DRC"
replace country = "Timor-Leste" if country == "Timor Leste"
replace country = "Gambia" if country == "The Gambia"
replace country = "Cook Island" if country == "Cook Is."
replace country = "Marshall Islands" if country == "Marshall Is."

merge m:1 isocode using "${datadir}/graphs and tables/cntrylvldata.dta", nogen
save "${datadir}/aux data/World Bank Official Boundaries - Admin 0/_worldmap_merged.dta", replace


* Fig. S1 | Sources of food in low- and middle-income countries:
geoframe create world_ADM0 _worldmap_merged.dta, replace shp(_worldmap_shp)
frame world_ADM0: geoframe select if inlist(isocode,"BRB"), into(barbados_shp) replace
frame world_ADM0: geoframe select if inlist(isocode,"TLS"), into(timorleste_shp) replace
frame world_ADM0: geoframe select if inlist(isocode,"DOM"), into(domrep_shp) replace
frame world_ADM0: geoframe select if inlist(isocode,"SLV"), into(salvador_shp) replace
frame world_ADM0: geoframe select if inlist(isocode,"GNB","SEN","GMB"), into(westafrica_shp) replace

geoplot ///
	(area world_ADM0 anyown, lcolor(black) color(sienna*0.2 sienna*0.5 sienna*0.8 sienna*1.1 sienna*1.4) cuts(0(20)100)) || ///
	(area barbados_shp anyown, lcolor(black) color(sienna*0.2 sienna*0.5 sienna*0.8 sienna*1.1 sienna*1.4) cuts(0(20)100)) /*For zoom*/ || /// 
	(area timorleste_shp anyown, lcolor(black) color(sienna*0.2 sienna*0.5 sienna*0.8 sienna*1.1 sienna*1.4) cuts(0(20)100)) /*For zoom*/ || /// 
	(area domrep_shp anyown, lcolor(black) color(sienna*0.2 sienna*0.5 sienna*0.8 sienna*1.1 sienna*1.4) cuts(0(20)100)) /*For zoom*/ || /// 
	(area salvador_shp anyown, lcolor(black) color(sienna*0.2 sienna*0.5 sienna*0.8 sienna*1.1 sienna*1.4) cuts(0(20)100)) /*For zoom*/ || /// 
	(area westafrica_shp anyown, lcolor(black) color(sienna*0.2 sienna*0.5 sienna*0.8 sienna*1.1 sienna*1.4) cuts(0(20)100)) /*For zoom*/ || /// 
	, tight graphregion(margin(zero)) plotregion(margin(b+5)) legend(region(color(white)) title("Any own" "consumption (%)") position(sw)) title("Panel B: Own consumption") name(owncons, replace)  ///
	zoom(2:30 700 60, circle connect(lp(dash)) lcolor(gs3)) /// 
	zoom(3:7 300 215, circle connect(lp(dash)) lcolor(gs3)) ///
	zoom(4:4 200 70, circle connect(lp(dash)) lcolor(gs3)) ///
	zoom(5:8 500 180, circle connect(lp(dash)) lcolor(gs3)) ///
	zoom(6:3 250 170, circle connect(lp(dash)) lcolor(gs3)) 
	
geoplot ///
	(area world_ADM0 onlypurch, lcolor(black) color(midblue*0.2 midblue*0.5 midblue*0.8 midblue*1.1 midblue*1.4) cuts(0(20)100)) || ///
	(area barbados_shp onlypurch, lcolor(black) color(midblue*0.2 midblue*0.5 midblue*0.8 midblue*1.1 midblue*1.4) cuts(0(20)100)) /*For zoom*/ || /// 
	(area timorleste_shp onlypurch, lcolor(black) color(midblue*0.2 midblue*0.5 midblue*0.8 midblue*1.1 midblue*1.4) cuts(0(20)100)) /*For zoom*/ || /// 
	(area domrep_shp onlypurch, lcolor(black) color(midblue*0.2 midblue*0.5 midblue*0.8 midblue*1.1 midblue*1.4) cuts(0(20)100)) /*For zoom*/ || /// 
	(area salvador_shp onlypurch, lcolor(black) color(midblue*0.2 midblue*0.5 midblue*0.8 midblue*1.1 midblue*1.4) cuts(0(20)100)) /*For zoom*/ || /// 
	(area westafrica_shp onlypurch, lcolor(black) color(midblue*0.2 midblue*0.5 midblue*0.8 midblue*1.1 midblue*1.4) cuts(0(20)100)) /*For zoom*/ || /// 
	, tight graphregion(margin(zero)) plotregion(margin(b+5)) legend(region(color(white)) title("Consumption exclusively" "from purchases (%)") position(sw)) title("Panel A: Purchases") name(purch, replace)  ///
	zoom(2:30 700 60, circle connect(lp(dash)) lcolor(gs3)) /// 
	zoom(3:7 300 215, circle connect(lp(dash)) lcolor(gs3)) ///
	zoom(4:4 200 70, circle connect(lp(dash)) lcolor(gs3)) ///
	zoom(5:8 500 180, circle connect(lp(dash)) lcolor(gs3)) ///
	zoom(6:3 250 170, circle connect(lp(dash)) lcolor(gs3)) 

graph combine purch owncons, scheme(s1color) rows(2) cols(1) altshrink ysize(16.0cm) xsize(18.0cm) imargin(zero)
graph export "${workdir}/graphs/worldmap.png", replace
graph export "${workdir}/graphs/worldmap.pdf", replace


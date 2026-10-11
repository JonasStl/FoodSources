/*******************************************************************************
Replication File for 
- Fig. S5 | Consumption from disaggregated food sources. 
*******************************************************************************/
use "$datadir/graphs and tables/othersources.dta", clear

foreach source in ARM BRB SUR DOM IND {
	quietly summarize `source'_sample, meanonly
	local n_`source' : display %12.0fc r(max)
	local n_`source' = strtrim("`n_`source''")
}

* Fig. S5:
graph set window fontface "Helvetica"

graph bar DDS_ARM_purch1_bin DDS_ARM_preservpurch_bin DDS_ARM_own1_bin DDS_ARM_preservown_bin DDS_ARM_hunt_bin DDS_ARM_remuninkind_bin DDS_ARM_gift_bin DDS_ARM_humassist_bin, ///
	bar(1, color(midblue) fcolor(midblue*0.6)) bar(2, color(midblue) fcolor(midblue*0.6))  ///
	bar(3, color(sienna) fcolor(sienna*0.6)) bar(4, color(sienna) fcolor(sienna*0.6)) bar(5, color(sienna) fcolor(sienna*0.6)) ///
	bar(6, color(gold) fcolor(gold*0.6)) bar(7, color(gold) fcolor(gold*0.6)) bar(8, color(gold) fcolor(gold*0.6)) ///
	showyvars  ytitle("Consumption (% of all households)", size(8pt)) yvaroptions(relabel(1 "Purchases" 2 "Preserved purchases" 3 "Own production" 4 "Preserved own production"  5 "From game/forest/field" 6 "Received as remuneration in kind" 7 "Received as gift" 8 "Humanitarian assistance") label(angle(45) labsize(8pt))) ///
	yscale(range(0 100)) ylab(0(20)100, labsize(8pt) angle(0)) legend(off) graphregion(color(white)) name(g1, replace) title("{bf:Armenia}", size(10pt)) nodraw ///
	note("{it:n = `n_ARM'}", ring(0) position(2) size(7pt))

graph bar DDS_BRB_purch_bin DDS_BRB_selfprod_bin DDS_BRB_selfsup_bin DDS_BRB_gift_bin DDS_BRB_recgov_bin DDS_BRB_recchurch_bin DDS_BRB_inkindpay_bin DDS_BRB_other_bin, ///
	bar(1, color(midblue) fcolor(midblue*0.6)) ///
	bar(2, color(sienna) fcolor(sienna*0.6)) bar(3, color(sienna) fcolor(sienna*0.6))  ///
	bar(4, color(gold) fcolor(gold*0.6)) bar(5, color(gold) fcolor(gold*0.6)) bar(6, color(gold) fcolor(gold*0.6)) bar(7, color(gold) fcolor(gold*0.6)) bar(8, color(gold) fcolor(gold*0.6)) ///
	showyvars yvaroptions(relabel(1 "Purchases" 2 "Self production" 3 "Self supply" 4 "Gift from other household" 5 "Received by government"  6 "Received by church" 7 "     Received as in-kind payment" 8 "Other") label(angle(45) labsize(8pt))) ///
	yscale(range(0 100)) ylab(0(20)100, labsize(8pt) angle(0)) legend(off) graphregion(color(white)) name(g2, replace) title("{bf:Barbados}", size(10pt)) nodraw ///
	note("{it:n = `n_BRB'}", ring(0) position(2) size(7pt))
	
graph bar DDS_SUR_purch_bin DDS_SUR_selfprod_bin DDS_SUR_selfsup_bin DDS_SUR_gift_bin DDS_SUR_recgov_bin DDS_SUR_recchurch_bin DDS_SUR_inkindpay_bin DDS_SUR_other_bin, ///
	bar(1, color(midblue) fcolor(midblue*0.6)) ///
	bar(2, color(sienna) fcolor(sienna*0.6)) bar(3, color(sienna) fcolor(sienna*0.6))  ///
	bar(4, color(gold) fcolor(gold*0.6)) bar(5, color(gold) fcolor(gold*0.6)) bar(6, color(gold) fcolor(gold*0.6)) bar(7, color(gold) fcolor(gold*0.6)) bar(8, color(gold) fcolor(gold*0.6)) ///
	showyvars ytitle("Consumption (% of all households)", size(8pt)) yvaroptions(relabel(1 "Purchases" 2 "Self production" 3 "Self supply" 4 "Gift from other household" 5 "Received by government"  6 "Received by church" 7 "         Received as in-kind payment" 8 "Other") label(angle(45) labsize(8pt))) ///
	yscale(range(0 100)) ylab(0(20)100, labsize(8pt) angle(0)) legend(off) graphregion(color(white)) name(g3, replace) title("{bf:Suriname}", size(10pt)) nodraw ///
	note("{it:n = `n_SUR'}", ring(0) position(2) size(7pt))
	
graph bar DDS_DOM_purch1_bin DDS_DOM_transferInstPub_bin DDS_DOM_own1_bin DDS_DOM_ownshop_bin DDS_DOM_inkindpay_bin DDS_DOM_giftfor_bin DDS_DOM_giftdom_bin DDS_DOM_giftNGO_bin DDS_DOM_giftInstPub_bin DDS_DOM_giftcom_bin, ///
	bar(1, color(midblue) fcolor(midblue*0.6)) bar(2, color(midblue) fcolor(midblue*0.6))  ///
	bar(3, color(sienna) fcolor(sienna*0.6)) bar(4, color(sienna) fcolor(sienna*0.6)) ///
	bar(5, color(gold) fcolor(gold*0.6)) bar(6, color(gold) fcolor(gold*0.6)) bar(7, color(gold) fcolor(gold*0.6)) bar(8, color(gold) fcolor(gold*0.6)) bar(9, color(gold) fcolor(gold*0.6)) ///
	showyvars ytitle("Consumption (% of all households)", size(9pt)) yvaroptions(relabel(1 "Purchases" 2 "Purch. with transfer from pub. inst." 3 "Own production" 4 "Retrieved from own shop" 5 "Received as in-kind payment"  6 "Gifts from foreign household" 7 "Gift from domestic household" 8 "Gift from NGO" 9 "Gift from public institution" 10 "Gift from company") label(angle(45) labsize(7pt))) ///
	yscale(range(0 100)) ylab(0(20)100, labsize(8pt) angle(0)) legend(off) graphregion(color(white)) name(g4, replace) title("{bf:Dominican Republic}", size(10pt)) nodraw ///
	note("{it:n = `n_DOM'}", ring(0) position(2) size(7pt))
	
graph bar DDS_IND_purch_bin DDS_IND_subPDS_bin DDS_IND_purchown_bin DDS_IND_own_bin DDS_IND_collect_bin DDS_IND_exch_bin DDS_IND_gift_bin DDS_IND_freePDS_bin DDS_IND_other_bin, ///
	bar(1, color(midblue) fcolor(midblue*0.6)) bar(2, color(midblue) fcolor(midblue*0.6))  ///
	bar(3, color(midblue) fcolor(sienna*0.6)) bar(4, color(sienna) fcolor(sienna*0.6)) ///
	bar(5, color(sienna) fcolor(sienna*0.6)) bar(6, color(gold) fcolor(gold*0.6)) bar(7, color(gold) fcolor(gold*0.6)) ///
	bar(8, color(gold) fcolor(gold*0.6)) bar(9, color(gs10) fcolor(gs10*0.6)) ///
	showyvars ytitle("Consumption (% of all households)", size(9pt)) yvaroptions(relabel(1 "Only purchase" 2 "Subsidized PDS" 3 "Both purchase and home-grown stock" 4 "Only home-grown stock"  5 "Only free collection" 6 "Only exchange of goods and services" 7 "Only gifts/charities" 8 "Free PDS"  9 "Others") label(angle(45) labsize(8pt))) ///
	yscale(range(0 100)) ylab(0(20)100, labsize(8pt) angle(0)) legend(off) graphregion(color(white)) name(g5, replace) title("{bf:India}", size(10pt)) nodraw ///
	note("{it:n = `n_IND'}", ring(0) position(2) size(7pt))

graph combine g1 g2 g3 g4 g5, graphregion(color(white)) rows(3) ysize(22.5cm) xsize(18.0cm) 
graph export "$workdir/graphs/Figure_S5.png", replace
graph export "$workdir/graphs/Figure_S5.pdf", replace


/*
Figure Notes:

Fig. S5. Consumption from disaggregated food sources.

Each panel shows the share of all households that consumed at least one food item during the recall period from each source category. Bars are grouped by source: purchases (blue), own production (brown), and gifts/in-kind (yellow). The y-axis is percent of households. Sources are not mutually exclusive. Estimates use survey weights. Sample sizes for each panel are reported in the respective sub-figure. Total sample size: N = 279,770 households.

*/

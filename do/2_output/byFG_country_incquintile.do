/*******************************************************************************
Replication File for
- Fig. S6 | Food group consumption by country and expenditure quintile. 
*******************************************************************************/
use "${datadir}/graphs and tables/byFG_country_incquint.dta", clear


*------------------------------------------------------------
* Excel table (not included)
*------------------------------------------------------------

* Settings
local outfile  "$workdir/tables/country_consumption_incquintiles.xlsx"
local fg_min   1
local fg_max   9
local q_min    1
local q_max    5
local decfmt   %5.0f   

* Helper: convert column number -> Excel letters
capture program drop _excelcol
program define _excelcol, rclass
    syntax , N(integer)
    local n = `n'
    local s ""
    while `n' > 0 {
        local r = mod(`n'-1,26)
        local s = char(`r' + 65) + "`s'"
        local n = int((`n' - `r' - 1)/26)
    }
    return local col "`s'"
end

* Start workbook
putexcel set "`outfile'", replace

* Row 1: top header with food-group blocks (each spans 5 quintile columns)
local startcol = 2                                  
forvalues g = `fg_min'/`fg_max' {
    local c1 = `startcol' + 5*(`g'-`fg_min')
    local c2 = `c1' + (`q_max' - `q_min')
    quietly _excelcol, n(`c1')
    local L1 = r(col)
    quietly _excelcol, n(`c2')
    local L2 = r(col)
    putexcel `L1'1 = "Food group `g'"      
    putexcel `L1'1:`L2'1, merge            
}

* Row 2: quintile labels under each food-group block
forvalues g = `fg_min'/`fg_max' {
    forvalues q = `q_min'/`q_max' {
        local coln = 2 + 5*(`g'-`fg_min') + (`q'-`q_min')
        quietly _excelcol, n(`coln')
        local L = r(col)
        putexcel `L'2 = "Q`q'"
    }
}
putexcel A1 = "", bold  
putexcel A2 = "Country", bold

* Countries to list
levelsof country, local(countries)

* Write rows: one per country
local r = 3
foreach C of local countries {
    putexcel A`r' = "`C'", bold
    forvalues g = `fg_min'/`fg_max' {
        forvalues q = `q_min'/`q_max' {
			preserve
				keep if country == "`C'" & exp_pc_quint == `q'

				* variable NAMES (not values)
				local v_est HDDS_`g'
				local v_ll  ll_HDDS_`g'
				local v_ul  ul_HDDS_`g'

				quietly count
				if r(N) {
					quietly summarize `v_est', meanonly
					local est = r(mean)

					quietly summarize `v_ll',  meanonly
					local ll  = r(mean)

					quietly summarize `v_ul',  meanonly
					local ul  = r(mean)

					* format numbers: integers; NA if ll/ul missing
					if missing(`est') local ests "NA"
					else              local ests = trim(strofreal(`est', "%9.0f"))

					if missing(`ll')  local lls  "NA"
					else              local lls  = trim(strofreal(`ll',  "%9.0f"))

					if missing(`ul')  local uls  "NA"
					else              local uls  = trim(strofreal(`ul',  "%9.0f"))

					local celltxt = "`ests' [`lls'; `uls']"
				}
				else local celltxt = ""
			restore

            local coln = 2 + 5*(`g'-`fg_min') + (`q'-`q_min')
            quietly _excelcol, n(`coln')
            local L = r(col)
            putexcel `L'`r' = "`celltxt'"
        }
    }
    local ++r
}

* Apply Helvetica 7pt to the whole sheet
local lastrow = `r'-1
local lastcol = 2 + 5*(`fg_max' - `fg_min') + (`q_max' - `q_min')
quietly _excelcol, n(`lastcol')
local Lend = r(col)

* Entire rectangle from A1 to the last filled cell:
putexcel A1:`Lend'`lastrow', font("Helvetica", 7)

* Optional: small header tweaks
putexcel A1:`Lend'1, font("Helvetica", 7)
putexcel A2:A`lastrow', font("Helvetica", 7)
putexcel A2:A`lastrow', font("Helvetica", 7)
display as text "Wrote: `outfile'"

gen Quintile = ""
replace Quintile = "Q1" if exp_pc_quint == 1
replace Quintile = "Q2" if exp_pc_quint == 2
replace Quintile = "Q3" if exp_pc_quint == 3
replace Quintile = "Q4" if exp_pc_quint == 4
replace Quintile = "Q5" if exp_pc_quint == 5


*** Fig. S6 | Food group consumption by country and expenditure quintile. 
capture drop _dummy z0
gen byte _dummy = 1
label define D 1 " "
label values _dummy D
gen byte z0 = 0


* labels-only strip (no ramp, no tiles)
graph set window fontface "Helvetica"

heatplot z0 country _dummy, discrete cuts(0 1) ///
    colors(white white) legend(off) ///
    yscale(noline reverse) xscale(noline) ///
    ylabel(, valuelabel angle(0) labsize(10pt)) xlabel(none) ///
    ytitle("") xtitle("") ///
    plotregion(margin(0 0 2 8)) graphregion(color(white) margin(0 0 0 0)) ///
    name(H_labels, replace) ysize(5) xsize(1) fxsize(12) fysize(220) nodraw

heatplot HDDS_1 country Quintile,  ///
    discrete colors(white sienna) ramp(top title("Cereals", size(12pt)) subtitle("") graphregion(color(white)) space(5) length(15) labels(,labsize(8pt))) ///
    cuts(0(10)100) yscale(noline reverse) xscale(noline) plotregion(margin(0 0 0 -5)) graphregion(color(white)) ///
    ylabel(none) xlabel(, noticks angle(0) labsize(10pt)) ytitle("") xtitle("") values(format(%9.0f) size(9pt))  ///
    name(HDDS_1, replace) ysize(5) xsize(3) missing(label("Missing") color(gs13)) nodraw
	
heatplot HDDS_2 country Quintile,  ///
    discrete colors(white orange) ramp(top title("Roots, tubers, and plantains", size(12pt)) subtitle("") graphregion(color(white)) space(5) length(15) labels(,labsize(8pt))) ///
    cuts(0(10)100) yscale(noline reverse) xscale(noline) plotregion(margin(0 0 0 -5)) graphregion(color(white)) ///
    ylabel(none) xlabel(, noticks angle(0) labsize(10pt)) ytitle("") xtitle("") values(format(%9.0f) size(9pt))  ///
    name(HDDS_2, replace) ysize(5) xsize(3) missing(label("Missing") color(gs13)) nodraw
	
heatplot HDDS_3 country Quintile,  ///
    discrete colors(white lavender) ramp(top title("Pulses, nuts and seeds", size(12pt)) subtitle("") graphregion(color(white)) space(5) length(15) labels(,labsize(8pt))) ///
    cuts(0(10)100) yscale(noline reverse) xscale(noline) plotregion(margin(0 0 0 -5)) graphregion(color(white)) ///
    ylabel(none) xlabel(, noticks angle(0) labsize(10pt)) ytitle("") xtitle("") values(format(%9.0f) size(9pt))  ///
    name(HDDS_3, replace) ysize(5) xsize(3) missing(label("Missing") color(gs13)) nodraw
	
heatplot HDDS_4 country Quintile,  ///
    discrete colors(white midblue) ramp(top title("Vegetables", size(12pt)) subtitle("") graphregion(color(white)) space(5) length(15) labels(,labsize(8pt))) ///
    cuts(0(10)100) yscale(noline reverse) xscale(noline) plotregion(margin(0 0 0 -5)) graphregion(color(white)) ///
    ylabel(none) xlabel(, noticks angle(0) labsize(10pt)) ytitle("") xtitle("") values(format(%9.0f) size(9pt))  ///
    name(HDDS_4, replace) ysize(5) xsize(3) missing(label("Missing") color(gs13)) nodraw
	
heatplot HDDS_5 country Quintile,  ///
    discrete colors(white midgreen) ramp(top title("Fruits", size(12pt)) subtitle("") graphregion(color(white)) space(5) length(15) labels(,labsize(8pt))) ///
    cuts(0(10)100) yscale(noline reverse) xscale(noline) plotregion(margin(0 0 0 -5)) graphregion(color(white)) ///
    ylabel(none) xlabel(, noticks angle(0) labsize(10pt)) ytitle("") xtitle("") values(format(%9.0f) size(9pt))  ///
    name(HDDS_5, replace) ysize(5) xsize(3) missing(label("Missing") color(gs13)) nodraw
	
heatplot HDDS_6 country Quintile,  ///
    discrete colors(white cranberry) ramp(top title("Meat", size(12pt)) subtitle("") graphregion(color(white)) space(5) length(15) labels(,labsize(8pt))) ///
    cuts(0(10)100) yscale(noline reverse) xscale(noline) plotregion(margin(0 0 0 -5)) graphregion(color(white)) ///
    ylabel(none) xlabel(, noticks angle(0) labsize(10pt)) ytitle("") xtitle("") values(format(%9.0f) size(9pt))  ///
    name(HDDS_6, replace) ysize(5) xsize(3) missing(label("Missing") color(gs13)) nodraw
	
heatplot HDDS_7 country Quintile,  ///
    discrete colors(white ebblue) ramp(top title("Fish and seafood", size(12pt)) subtitle("") graphregion(color(white)) space(5) length(15) labels(,labsize(8pt))) ///
    cuts(0(10)100) yscale(noline reverse) xscale(noline) plotregion(margin(0 0 0 -5)) graphregion(color(white)) ///
    ylabel(none) xlabel(, noticks angle(0) labsize(10pt)) ytitle("") xtitle("") values(format(%9.0f) size(9pt))  ///
    name(HDDS_7, replace) ysize(5) xsize(3) missing(label("Missing") color(gs13)) nodraw
	
heatplot HDDS_8 country Quintile,  ///
    discrete colors(white gray) ramp(top title("Milk and dairy products", size(12pt)) subtitle("") graphregion(color(white)) space(5) length(15) labels(,labsize(8pt))) ///
    cuts(0(10)100) yscale(noline reverse) xscale(noline) plotregion(margin(0 0 0 -5)) graphregion(color(white)) ///
    ylabel(none) xlabel(, noticks angle(0) labsize(10pt)) ytitle("") xtitle("") values(format(%9.0f) size(9pt))  ///
    name(HDDS_8, replace) ysize(5) xsize(3) missing(label("Missing") color(gs13)) nodraw
	
heatplot HDDS_9 country Quintile,  ///
    discrete colors(white gold) ramp(top title("Eggs", size(12pt)) subtitle("") graphregion(color(white)) space(5) length(15) labels(,labsize(8pt))) ///
    cuts(0(10)100) yscale(noline reverse) xscale(noline) plotregion(margin(0 0 0 -5)) graphregion(color(white)) ///
    ylabel(none) xlabel(, noticks angle(0) labsize(10pt)) ytitle("") xtitle("") values(format(%9.0f) size(9pt))  ///
    name(HDDS_9, replace) ysize(5) xsize(3) missing(label("Missing") color(gs13)) nodraw
	
	
graph combine H_labels HDDS_1 HDDS_2 HDDS_3 HDDS_4 HDDS_5 HDDS_6 HDDS_7 HDDS_8 HDDS_9, rows(1) xcommon ycommon ///
    imargin(zero) graphregion(color(white) margin(b-2 t-2)) ysize(18cm) xsize(35cm)
graph export "${workdir}/graphs/FG_country_incquint_heat.pdf", as(pdf) fontface("Helvetica") replace
graph export "${workdir}/graphs/FG_country_incquint_heat.png", replace

/* Figure Notes:




*/

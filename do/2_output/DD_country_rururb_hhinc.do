/*******************************************************************************
Replication File for
- Extended Data Fig. 4 | Rural–urban and poverty gradients in HDDS and sourcing. 
- Fig. S19 | Differences in healthy HDDS and sourcing across location–income groups. 
*******************************************************************************/
use "${datadir}/graphs and tables/DD_country_rururb_hhinc.dta", clear

* Change Congo label for nicer output:
label define country_enc 11 "DRC 2012", modify


* Calculate barriers
gen _ruralpoor = DDS_hlthy if exp_pc_terc == 1 & urban == 0
gen _urbanrich = DDS_hlthy if exp_pc_terc == 3 & urban == 1
gen _ruralrich = DDS_hlthy if exp_pc_terc == 3 & urban == 0
gen _urbanpoor = DDS_hlthy if exp_pc_terc == 1 & urban == 1
bysort country_enc: egen ruralpoor = max(_ruralpoor)
bysort country_enc: egen urbanrich = max(_urbanrich)
bysort country_enc: egen ruralrich = max(_ruralrich)
bysort country_enc: egen urbanpoor = max(_urbanpoor)

gen _ruralpoor_own = own_perc if exp_pc_terc == 1 & urban == 0
gen _urbanrich_own = own_perc if exp_pc_terc == 3 & urban == 1
gen _ruralrich_own = own_perc if exp_pc_terc == 3 & urban == 0
gen _urbanpoor_own = own_perc if exp_pc_terc == 1 & urban == 1
bysort country_enc: egen ruralpoor_own = max(_ruralpoor_own)
bysort country_enc: egen urbanrich_own = max(_urbanrich_own)
bysort country_enc: egen ruralrich_own = max(_ruralrich_own)
bysort country_enc: egen urbanpoor_own = max(_urbanpoor_own)

gen _ruralpoor_DDSown = DDS_hlthy_own if exp_pc_terc == 1 & urban == 0
gen _urbanrich_DDSown = DDS_hlthy_own if exp_pc_terc == 3 & urban == 1
gen _ruralrich_DDSown = DDS_hlthy_own if exp_pc_terc == 3 & urban == 0
gen _urbanpoor_DDSown = DDS_hlthy_own if exp_pc_terc == 1 & urban == 1
bysort country_enc: egen ruralpoor_DDSown = max(_ruralpoor_DDSown)
bysort country_enc: egen urbanrich_DDSown = max(_urbanrich_DDSown)
bysort country_enc: egen ruralrich_DDSown = max(_ruralrich_DDSown)
bysort country_enc: egen urbanpoor_DDSown = max(_urbanpoor_DDSown)

gen _ruralpoor_purch = purch_perc if exp_pc_terc == 1 & urban == 0
gen _urbanrich_purch = purch_perc if exp_pc_terc == 3 & urban == 1
gen _ruralrich_purch = purch_perc if exp_pc_terc == 3 & urban == 0
gen _urbanpoor_purch = purch_perc if exp_pc_terc == 1 & urban == 1
bysort country_enc: egen ruralpoor_purch = max(_ruralpoor_purch)
bysort country_enc: egen urbanrich_purch = max(_urbanrich_purch)
bysort country_enc: egen ruralrich_purch = max(_ruralrich_purch)
bysort country_enc: egen urbanpoor_purch = max(_urbanpoor_purch)

gen _ruralpoor_DDSpurch = DDS_hlthy_purch if exp_pc_terc == 1 & urban == 0
gen _urbanrich_DDSpurch = DDS_hlthy_purch if exp_pc_terc == 3 & urban == 1
gen _ruralrich_DDSpurch = DDS_hlthy_purch if exp_pc_terc == 3 & urban == 0
gen _urbanpoor_DDSpurch = DDS_hlthy_purch if exp_pc_terc == 1 & urban == 1
bysort country_enc: egen ruralpoor_DDSpurch = max(_ruralpoor_DDSpurch)
bysort country_enc: egen urbanrich_DDSpurch = max(_urbanrich_DDSpurch)
bysort country_enc: egen ruralrich_DDSpurch = max(_ruralrich_DDSpurch)
bysort country_enc: egen urbanpoor_DDSpurch = max(_urbanpoor_DDSpurch)

drop _ruralpoor _urbanrich _ruralrich _urbanpoor _ruralpoor_own _urbanrich_own _ruralrich_own _urbanpoor_own _ruralpoor_purch _urbanrich_purch _ruralrich_purch _urbanpoor_purch

* Graph that shows physical constriants
gen phyconst_poor = ruralpoor-urbanpoor
gen phyconst_rich = ruralrich-urbanrich
gen phyconst_poor_own = ruralpoor_own-urbanpoor_own
gen phyconst_rich_own = ruralrich_own-urbanrich_own
gen phyconst_poor_purch = ruralpoor_purch-urbanpoor_purch
gen phyconst_rich_purch = ruralrich_purch-urbanrich_purch
gen phyconst_poor_DDSown = ruralpoor_DDSown-urbanpoor_DDSown
gen phyconst_rich_DDSown = ruralrich_DDSown-urbanrich_DDSown
gen phyconst_poor_DDSpurch = ruralpoor_DDSpurch-urbanpoor_DDSpurch
gen phyconst_rich_DDSpurch = ruralrich_DDSpurch-urbanrich_DDSpurch

gen econconst_rural = ruralpoor-ruralrich
gen econconst_urban = urbanpoor-urbanrich
gen econconst_rural_own = ruralpoor_own-ruralrich_own
gen econconst_urban_own = urbanpoor_own-urbanrich_own
gen econconst_rural_purch = ruralpoor_purch-ruralrich_purch
gen econconst_urban_purch = urbanpoor_purch-urbanrich_purch
gen econconst_rural_DDSown = ruralpoor_DDSown-ruralrich_DDSown
gen econconst_urban_DDSown = urbanpoor_DDSown-urbanrich_DDSown
gen econconst_rural_DDSpurch = ruralpoor_DDSpurch-ruralrich_DDSpurch
gen econconst_urban_DDSpurch = urbanpoor_DDSpurch-urbanrich_DDSpurch

gen desiredhdds = ruralpoor-urbanrich
gen change_own = ruralpoor_DDSown-urbanrich_DDSown
gen change_own_perc = ruralpoor_own-urbanrich_own
gen change_purch = ruralpoor_DDSpurch-urbanrich_DDSpurch
gen change_purch_perc = ruralpoor_purch-urbanrich_purch




preserve

********************************************************************************
* Fig. S19 | Differences in healthy HDDS and sourcing across location–income groups. (formatted Excel)
********************************************************************************
keep country_enc urban exp_pc_terc DDS_hlthy_purch purch_perc DDS_hlthy_own own_perc
keep if inlist(exp_pc_terc,1,3)

* key for the four cells we want
gen block = cond(urban==0 & exp_pc_terc==1, "_r_poor",  ///
          cond(urban==0 & exp_pc_terc==3, "_r_rich", ///
          cond(urban==1 & exp_pc_terc==1, "_u_poor", "_u_rich")))

drop urban exp_pc_terc
reshape wide DDS_hlthy_purch purch_perc DDS_hlthy_own own_perc, ///
       i(country_enc) j(block) string

order country_enc ///
      DDS_hlthy_purch_r_poor purch_perc_r_poor DDS_hlthy_own_r_poor own_perc_r_poor ///
      DDS_hlthy_purch_u_poor purch_perc_u_poor DDS_hlthy_own_u_poor own_perc_u_poor ///
	  DDS_hlthy_purch_r_rich purch_perc_r_rich DDS_hlthy_own_r_rich own_perc_r_rich ///
      DDS_hlthy_purch_u_rich purch_perc_u_rich DDS_hlthy_own_u_rich own_perc_u_rich
sort country_enc


putexcel set "${workdir}/tables/HDDS_deprivation.xlsx", replace sheet("Mean")

* Row 1–2: top/band headers with merges
putexcel A1:A4 = "Country & Year", merge bold hcenter vcenter

putexcel B1:I1 = "Poorest tercile",  merge hcenter vcenter bold
putexcel J1:Q1 = "Richest tercile",  merge hcenter vcenter bold

putexcel B2:E2 = "Rural", merge hcenter vcenter bold
putexcel F2:I2 = "Urban", merge hcenter vcenter bold
putexcel J2:M2 = "Rural", merge hcenter vcenter bold
putexcel N2:Q2 = "Urban", merge hcenter vcenter bold

* Row 3: column labels repeated in each block
putexcel B3 = "HDDS purch" C3 = "% from tot." D3 = "HDDS own" E3 = "% from tot." ///
        F3 = "HDDS purch" G3 = "% from tot." H3 = "HDDS own" I3 = "% from tot." ///
        J3 = "HDDS purch" K3 = "% from tot." L3 = "HDDS own" M3 = "% from tot." ///
        N3 = "HDDS purch" O3 = "% from tot." P3 = "HDDS own" Q3 = "% from tot.", hcenter vcenter
		
* Write (1) … (16) into B4:Q4
local cols "B C D E F G H I J K L M N O P Q"
local i = 1
foreach c of local cols {
    putexcel `c'4 = "(`i')", hcenter vcenter
    local ++i
}

export excel country_enc ///
      DDS_hlthy_purch_r_poor purch_perc_r_poor DDS_hlthy_own_r_poor own_perc_r_poor ///
      DDS_hlthy_purch_u_poor purch_perc_u_poor DDS_hlthy_own_u_poor own_perc_u_poor ///
	  DDS_hlthy_purch_r_rich purch_perc_r_rich DDS_hlthy_own_r_rich own_perc_r_rich ///
      DDS_hlthy_purch_u_rich purch_perc_u_rich DDS_hlthy_own_u_rich own_perc_u_rich ///
    using "${workdir}/tables/HDDS_deprivation.xlsx", sheet("Mean") sheetmodify cell(A4) firstrow(variables) keepcellfmt

* erase the variable-name row Excel just wrote
putexcel set "${workdir}/tables/HDDS_deprivation.xlsx", sheet("Mean") modify  
putexcel A4:Q4 = ""                            

local r1 = 5
local r2 = _N + 4

foreach col in B D F H J L N P {
    putexcel `col'`r1':`col'`r2', nformat("0.0")     // HDDS columns
}
foreach col in C E G I K M O Q {
    putexcel `col'`r1':`col'`r2', nformat("0")       // % columns
}

* Adjust Font and Font Size
putexcel set "${workdir}/tables/HDDS_deprivation.xlsx", sheet("Mean") modify
putexcel A1:R50, font("Helvetica", 7) 

/*
Manual steps in Excel:
- Set COlumn width of columns B to Q equal to 3.67 and column A equal to 11.5
- Wrap third row and align these columns centrally
- Add conditional colorings:
	- "Blue" for 0 to 9 in columns for purchases (1, 5, 9, 13)
	- "Blue" for 0 to 100 in columns for purchases (2, 6, 10, 14)
	- "Orange, Accent 2, Darker 50%" for 0 to 9 in columns for HDDS own consumption (3, 7, 11, 15)
	- "Orange, Accent 2, Darker 50%" for 0 to 100 in columns for own consumption share (4, 8, 12, 16)
- Mark entire table and copy to the dired processor as picture

*/
restore



********************************************************************************
* Extended Data Fig. 4 | Rural–urban and poverty gradients in HDDS and sourcing. (formatted Excel)
********************************************************************************

preserve
keep country_enc exp_pc_terc urban ///
     desiredhdds change_own change_own_perc change_purch change_purch_perc ///
     phyconst_poor phyconst_poor_DDSown phyconst_poor_own phyconst_poor_DDSpurch phyconst_poor_purch ///
     phyconst_rich phyconst_rich_DDSown phyconst_rich_own phyconst_rich_DDSpurch phyconst_rich_purch ///
     econconst_rural econconst_rural_DDSown econconst_rural_own econconst_rural_DDSpurch econconst_rural_purch ///
     econconst_urban econconst_urban_DDSown econconst_urban_own econconst_urban_DDSpurch econconst_urban_purch

keep if exp_pc_terc == 1 & urban == 0

drop exp_pc_terc urban
sort country_enc

putexcel set "${workdir}/tables/HDDS_differences.xlsx", replace sheet("Differences")


* Left stub
putexcel A1:A4 = "Country & Year of survey start", merge bold hcenter vcenter txtwrap

* Column blocks (B:Z)
* Combined (RT1–UT3)
putexcel B1:F2 = "Combined (RT1–UT3)", merge hcenter vcenter bold
putexcel B3:B4 = "ΔTotal  HDDS", merge hcenter vcenter bold
putexcel C3:D3 = "Own consumption", merge hcenter vcenter bold
putexcel C4 = "ΔHDDS"  
putexcel D3 = "Δ%"
putexcel E3:F3 = "Purchases",       merge hcenter vcenter bold
putexcel E4 = "ΔHDDS"  
putexcel F3 = "Δ%"

* Physical constraints
* Tercile 1 (RT1–UT1)
putexcel G1:P1 = "Physical constraints", merge hcenter vcenter bold
putexcel G2:K2 = "Tercile 1 (RT1–UT1)",  merge hcenter vcenter italic
putexcel G3:G4 = "ΔTotal HDDS",  merge hcenter vcenter bold
putexcel H3:I3 = "Own consumption", merge hcenter vcenter
putexcel H4 = "ΔHDDS"  
putexcel I4 = "Δ%"
putexcel J3:K3 = "Purchases",       merge hcenter vcenter
putexcel J4 = "ΔHDDS"  
putexcel K4 = "Δ%"

* Tercile 3 (RT3–UT3)
putexcel L2:P2 = "Tercile 3 (RT3–UT3)", merge hcenter vcenter italic
putexcel L3:L4 = "ΔTotal HDDS", merge hcenter vcenter bold
putexcel M3:N3 = "Own consumption", merge hcenter vcenter
putexcel M4 = "ΔHDDS"  
putexcel N4 = "Δ%"
putexcel O3:P3 = "Purchases",       merge hcenter vcenter
putexcel O4 = "ΔHDDS"  
putexcel P4 = "Δ%"

* Economic constraints
* Rural (RT1–RT3)
putexcel Q1:Z1 = "Economic constraints", merge hcenter vcenter bold
putexcel Q2:U2 = "Rural (RT1–RT3)",      merge hcenter vcenter italic
putexcel Q3:Q4 = "ΔTotal HDDS", merge hcenter vcenter bold
putexcel R3:S3 = "Own consumption", merge hcenter vcenter
putexcel R4 = "ΔHDDS"  
putexcel S4 = "Δ%"
putexcel T3:U3 = "Purchases",       merge hcenter vcenter
putexcel T4 = "ΔHDDS"  
putexcel U4 = "Δ%"

* Urban (UT1–UT3)
putexcel V2:Z2 = "Urban (UT1–UT3)", merge hcenter vcenter italic
putexcel V3:V4 = "ΔTotal HDDS", merge hcenter vcenter bold
putexcel W3:X3 = "Own consumption", merge hcenter vcenter
putexcel W4 = "ΔHDDS"  
putexcel X4 = "Δ%"
putexcel Y3:Z3 = "Purchases",       merge hcenter vcenter
putexcel Y4 = "ΔHDDS"  
putexcel Z4 = "Δ%"

* Global header styling
putexcel A1:Z3, font("Helvetica", 7) 
putexcel A1:Z3, border(bottom, thin)
putexcel A4:Z4, border(bottom, thin)

*--- 4) Data export (row 4 down) ----------------------------------------------
export excel country_enc ///
    desiredhdds change_own change_own_perc change_purch change_purch_perc ///
    phyconst_poor phyconst_poor_DDSown phyconst_poor_own phyconst_poor_DDSpurch phyconst_poor_purch ///
    phyconst_rich phyconst_rich_DDSown phyconst_rich_own phyconst_rich_DDSpurch phyconst_rich_purch ///
    econconst_rural econconst_rural_DDSown econconst_rural_own econconst_rural_DDSpurch econconst_rural_purch ///
    econconst_urban econconst_urban_DDSown econconst_urban_own econconst_urban_DDSpurch econconst_urban_purch ///
    using "${workdir}/tables/HDDS_differences.xlsx", sheet("Differences") sheetmodify cell(A5) keepcellfmt   

*--- 5) Number formats, column widths, fonts ----------------------------------
local r1 = 4
local r2 = _N + 4

* ΔHDDS columns: one decimal
foreach col in B G L Q V ///
               C H M R W ///
               E J O T Y {
    putexcel `col'`r1':`col'`r2', nformat("0.0")
}

* Δ% columns: integer
foreach col in D I N S X F K P U Z {
    putexcel `col'`r1':`col'`r2', nformat("0")
}

* Fonts and alignment
putexcel A1:Z`r2', font("Helvetica", 7)
putexcel B`r1':Z`r2', right vcenter

/*
Manual steps in Excel:
- Set COlumn width of columns B to Z equal to 4.5 and column A equal to 11.5
- Set hight of rows 5 to 40 equal to 10
- Wrap third row and align these columns centrally
- Add conditional colorings:
	- "Red" for 0 to 9 in total HDDS columns
	- "Blue" for 0 to 9 in columns for HDDS purchases (1, 5, 9, 13)
	- "Blue" for 0 to 100 in columns for purchases (2, 6, 10, 14)
	- "Orange, Accent 2, Darker 50%" for 0 to 9 in columns for HDDS own consumption (3, 7, 11, 15)
	- "Orange, Accent 2, Darker 50%" for 0 to 100 in columns for own consumption share (4, 8, 12, 16)
- Mark entire table and copy to the dired processor as picture (wide format)
*/


restore


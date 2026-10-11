/*******************************************************************************
Path-neutral setup for the FoodSources replication package.

Run Stata from the package root, then execute:
    do do/01_master.do
*******************************************************************************/

version 17
clear all
set more off
set scheme s1color

global workdir "`c(pwd)'"
capture confirm file "${workdir}/README.md"
if _rc {
    display as error "Start Stata in the FoodSources package root before running the master file."
    exit 601
}

global datadir "${workdir}/data"
capture mkdir "${workdir}/graphs"
capture mkdir "${workdir}/tables"

* Install user-written commands only when they are unavailable.
capture which sencode
if _rc ssc install sencode

capture which mm_colruns
if _rc ssc install moremata

capture which heatplot
if _rc ssc install heatplot

capture which colorpalette
if _rc ssc install palettes

capture which colrspace
if _rc ssc install colrspace

capture which gstats
if _rc ssc install gtools

capture which grc1leg2
if _rc ssc install grc1leg2

capture which kountry
if _rc ssc install kountry

capture which labmask
if _rc ssc install labutil2

capture which geoplot
if _rc ssc install geoplot

display as result "FoodSources paths and dependencies are ready."

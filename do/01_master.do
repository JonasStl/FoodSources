/*******************************************************************************
Master replication file: all final manuscript figures and tables.
*******************************************************************************/

do "do/00_setup.do"

* Main figures
do "${workdir}/do/figures/Figure_1.do"
do "${workdir}/do/figures/Figure_2.do"
do "${workdir}/do/figures/Figure_3_and_Figure_S13.do"
do "${workdir}/do/figures/Figure_4_and_Figure_S11.do"
do "${workdir}/do/figures/Figure_5.do"

* Extended Data figures
do "${workdir}/do/figures/Extended_Data_Figure_1_and_Figure_S3.do"
do "${workdir}/do/figures/Extended_Data_Figure_2.do"
do "${workdir}/do/figures/Extended_Data_Figure_3.do"
do "${workdir}/do/figures/Extended_Data_Figure_4_and_Figure_S20.do"

* Supplementary figures
do "${workdir}/do/figures/Figure_S1.do"
do "${workdir}/do/figures/Figure_S2.do"
do "${workdir}/do/figures/Figure_S4.do"
do "${workdir}/do/figures/Figure_S5.do"
do "${workdir}/do/figures/Figure_S6.do"
do "${workdir}/do/figures/Figure_S7.do"
do "${workdir}/do/figures/Figure_S8.do"
do "${workdir}/do/figures/Figure_S9.do"
do "${workdir}/do/figures/Figure_S10.do"
do "${workdir}/do/figures/Figure_S12.do"
do "${workdir}/do/figures/Figure_S14.do"
do "${workdir}/do/figures/Figure_S15.do"
do "${workdir}/do/figures/Figure_S16.do"
do "${workdir}/do/figures/Figures_S17-S19.do"
do "${workdir}/do/figures/Figure_S21.do"
do "${workdir}/do/figures/Figure_S22.do"

* Supplementary tables
do "${workdir}/do/tables/Table_S1.do"
do "${workdir}/do/tables/Table_S2.do"

display as result "ALL FINAL FIGURES AND TABLES COMPLETED"

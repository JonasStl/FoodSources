# Food Sourcing and Diets: Evidence from 50 Low- and Middle-Income Countries

Replication package for Jonas Stehl, Kibrom T. Sibhatu, Lindsay M. Jaacks, and
Sebastian Vollmer.

This package reproduces the final figures and supplementary tables for the
food-sources paper. It contains only the programs used for outputs retained in
the current manuscript and Supplementary Information.

## Software

- Stata 17 or later (Stata/SE recommended).
- Internet access on the first run if any user-written Stata commands listed in
  `do/00_setup.do` are not already installed.

The setup checks for and, when needed, installs `sencode`, `moremata`,
`heatplot`, `palettes`, `colrspace`, `gtools`, `grc1leg2`, `kountry`,
`labutil2`, and `geoplot` from SSC.

## Run the package

1. Start Stata with this directory as the working directory.
2. Run:

   ```stata
   do do/01_master.do
   ```

The setup is path-neutral: it derives all paths from Stata's current working
directory and contains no user-specific path. Figures are written to `graphs/`
and formatted table workbooks to `tables/`.

## Program-to-output map

| Program | Manuscript output |
|---|---|
| `do/figures/Figure_1.do` | Figure 1, panels a–b |
| `do/figures/Figure_2.do` | Figure 2 |
| `do/figures/Figure_3_and_Figure_S13.do` | Figure 3 and Figure S13 |
| `do/figures/Figure_4_and_Figure_S11.do` | Figure 4 and Figure S11 |
| `do/figures/Figure_5.do` | Figure 5 |
| `do/figures/Extended_Data_Figure_1_and_Figure_S3.do` | Extended Data Figure 1 and Figure S3 |
| `do/figures/Extended_Data_Figure_2.do` | Extended Data Figure 2 |
| `do/figures/Extended_Data_Figure_3.do` | Extended Data Figure 3 |
| `do/figures/Extended_Data_Figure_4_and_Figure_S20.do` | Extended Data Figure 4 and Figure S20 |
| `do/figures/Figure_S1.do` | Figure S1 |
| `do/figures/Figure_S2.do` | Figure S2, panels a–d and combined figure |
| `do/figures/Figure_S4.do`–`Figure_S10.do` | Figures S4–S10 |
| `do/figures/Figure_S12.do` | Figure S12 |
| `do/figures/Figure_S14.do`–`Figure_S16.do` | Figures S14–S16 |
| `do/figures/Figures_S17-S19.do` | Figures S17–S19 |
| `do/figures/Figure_S21.do`–`Figure_S22.do` | Figures S21–S22 |
| `do/tables/Table_S1.do` | Table S1 |
| `do/tables/Table_S2.do` | Table S2 |

Some figures share one program because they are alternative views of the same
intermediate estimates. `_prepare_table1_wdi.do` is a shared helper used only
by Figures 1a and S2.


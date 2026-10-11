# Data inputs

The local replication deposit includes the reduced, analysis-ready Stata files
needed by the final figure and table programs. These files were regenerated
from the latest household-level analysis datasets before the package was
assembled.

The `data/` directory is intentionally excluded by the repository's
`.gitignore`, so restricted or redistributable data are not uploaded to GitHub
accidentally. Before running a GitHub clone, obtain the data deposit and retain
this structure:

- `data/graphs and tables/`: reduced inputs for the final figures and tables;
- `data/wbdata.dta`: matched World Development Indicators used in Figures 1a
  and S2;
- `data/aux data/World Bank Official Boundaries - Admin 0/`: geographic inputs
  used in Figure S1.

The large household-level construction files are not required to run this
package and are not included.

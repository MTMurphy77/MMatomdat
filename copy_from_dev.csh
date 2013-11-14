#!/bin/tcsh

\cp -f ../MMatomdat.ods .
\cp -f ../MMatomdat.xlsx .
rsync -a --delete ../6JSymbol* .
\rm -f MM_*.tex; rsync -a --delete ../MM_*.tex .
\rm -f MM_*.dat; rsync -a --delete ../MM_*.dat .
\rm -rf IHFstruct; rsync -a --copy-links --delete ../IHFstruct .
\rm -f MMatomdat_*.csv; rsync -a --delete ../MMatomdat_*.csv .
\rm -f MMatomdat_*.tex; rsync -a --delete ../MMatomdat_*.tex .
\rm -f MMatomdat_*.csh; rsync -a --delete ../MMatomdat_*.csh .
\rm -f MMatomdat_*.awk; rsync -a --delete ../MMatomdat_*.awk .
\rm -f VPFIT10_atom_*.dat; rsync -a --delete ../VPFIT10_atom_*.dat .
\rm -f README.txt; rsync -a ../README.txt .
\cp README.txt README.md

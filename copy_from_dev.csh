#!/bin/tcsh

\cp -f ../MMatomdat.ods .
\cp -f ../MMatomdat.xlsx .
rsync -a --delete ../MM_*.tex .
rsync -a --delete ../MM_*.dat .
rsync -a --delete ../IHFstruct .
rsync -a --delete ../MMatomdat_*.csv .
rsync -a --delete ../MMatomdat_*.tex .
rsync -a --delete ../MMatomdat_*.csh .
rsync -a --delete ../MMatomdat_*.awk .
rsync -a --delete ../VPFIT10_atom_*.dat .
rsync -a ../README.txt .

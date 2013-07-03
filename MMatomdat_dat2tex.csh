#!/bin/tcsh

set DATFILE = 'MMatomdat.dat'
set TEXFILE = 'MMatomdat_tab.tex' ; /bin/rm -rf $TEXFILE ; touch $TEXFILE

awk -f MMatomdat_dat2tex.awk $DATFILE >> $TEXFILE

#!/bin/tcsh

set IHFSDIR = 'IHFstruct'
set INPREFIX = 'MMatomdat'
set INSUFFIX = '.csv'
set OUTSUFFIX = '.dat'

if (! -d $IHFSDIR) then
    mkdir $IHFSDIR
endif

foreach ELEMENT ( Na Mg Al Si Ca Ti Cr Mn Fe Ni Zn )
    set CSVFILE = `echo $INPREFIX"_"$ELEMENT$INSUFFIX`
    set OUTFILE = `echo $IHFSDIR"/"$ELEMENT$OUTSUFFIX` ; rm -f $OUTFILE; touch $OUTFILE
    awk -f MMatomdat_csv2isodat.awk $CSVFILE >> $OUTFILE
end

exit

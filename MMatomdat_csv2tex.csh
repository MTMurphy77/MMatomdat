#!/bin/tcsh

set INPREFIX = 'MMatomdat'
set INSUFFIX = '.csv'
set OUTPREFIX = 'MM'
set OUTVERS = `date "+%Y-%m-%d"`
set OUTSUFFIX = '.tex'
set TABHEAD = 'MMatomdat_table_head.tex'
set TABTAIL = 'MMatomdat_table_tail.tex'

foreach ELEMENT ( Na Mg Al Si Ca Ti Cr Mn Fe Ni Zn )
    set CSVFILE = `echo $INPREFIX"_"$ELEMENT$INSUFFIX`
    set OUTFILE = `echo $OUTPREFIX"_"$ELEMENT"-"$OUTVERS$OUTSUFFIX` ; rm -f $OUTFILE; touch $OUTFILE
    set CAPFILE = `echo $INPREFIX"_"$ELEMENT"_caption"$OUTSUFFIX`
    set TABLABEL = `echo $ELEMENT`
    @ SLINE = 1; @ ELINE = `grep -n "CAPTION" $TABHEAD | awk '{printf "%d",substr($1,1,length($1)-1)}'`; @ ELINE = $ELINE - 1;
    @ NLINE = `wc $TABHEAD | awk '{print $1}'`
    printline $TABHEAD $SLINE $ELINE >> $OUTFILE
    cat $CAPFILE >> $OUTFILE 
    @ SLINE = ($NLINE - $ELINE) - 1
    tail -$SLINE $TABHEAD | sed 's/LABEL/'$TABLABEL'/' >> $OUTFILE

    awk -f MMatomdat_csv2tex.awk $CSVFILE >> $OUTFILE

    cat $TABTAIL >> $OUTFILE
end

exit

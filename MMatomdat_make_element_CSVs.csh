#!/bin/tcsh


foreach ELEM ( Mg Al Si Ti Cr Mn Fe Ni Zn )
    set ELEMCSV = `echo "MMatomdat_"$ELEM".csv"` ; /bin/rm -f $ELEMCSV; touch $ELEMCSV
    @ i = 0
    @ NFILE = `/bin/ls MMatomdat_${ELEM}[IV]*.csv | wc | awk '{print $1}'`
    foreach IONCSV ( `/bin/ls MMatomdat_${ELEM}[IV]*.csv` )
	@ i = $i + 1
	@ SLINE = `grep -n "Summary" $IONCSV | head -1 | sed 's/:/ /' | awk '{print $1}'`
	if ($i>1) then
	    @ SLINE = $SLINE + 1
	endif
	@ ELINE = `grep -n "END" $IONCSV | head -1 | sed 's/:/ /' | awk '{print $1}'`
	if ($i<$NFILE) then
	    @ ELINE = $ELINE - 1
	endif
	printline $IONCSV $SLINE $ELINE >> $ELEMCSV
    end
end

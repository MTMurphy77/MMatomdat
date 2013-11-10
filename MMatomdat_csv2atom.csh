#!/bin/tcsh

set INPREFIX = 'MMatomdat'
set INSUFFIX = '.csv'
set VPATOM = 'VPFIT10_atom_2011-09-05.dat'
set OUTPREFIX = 'MM_VPFIT'
set OUTVERS = `date "+%Y-%m-%d"`
set OUTSUFFIX = '.dat'
set OUTISO = `echo $OUTPREFIX"_"$OUTVERS$OUTSUFFIX` ; rm -f $OUTISO
set OUTNOISO = `echo $OUTPREFIX"_"$OUTVERS"_noiso"$OUTSUFFIX` ; rm -f $OUTNOISO
set TEMP1 = 'MMatomdat_csv2atom_temp1.dat' ; rm -f $TEMP1 ; touch $TEMP1
set TEMP2 = 'MMatomdat_csv2atom_temp2.dat' ; rm -f $TEMP2 ; touch $TEMP2
set WQLAB = 'w,q:Murphy:2014'
set FGLAB = 'f,g:M03'

awk '{if ($1=="FeI") { \
if (substr($2,1,6)=="2967.7") {printf "FeI   2984.44\n%s\n",$0} \
else if (substr($2,1,6)=="3720.9") {printf "FeI   3861.00\n%s\nFeI   3441.59\n",$0} \
else print $0} else print $0}' $VPATOM > $OUTNOISO
foreach ION ( NaI MgI MgII AlII AlIII SiII SiIV CaII TiII CrII MnII FeI FeII NiII ZnII )
    set CSVFILE = `echo $INPREFIX"_"$ION$INSUFFIX`
    if (`echo "$ION" | awk '{if ($1!="AlIII" && $1!="MnII") print 1; else print 0}'`) then
	awk -f MMatomdat_csv2atom.awk $CSVFILE | awk '{print $0,"'$WQLAB'","'$FGLAB'"}' | grep "CMP\|ALL" > $TEMP1
    else
	awk -f MMatomdat_csv2atom.awk $CSVFILE | awk '{print $0,"'$WQLAB'","'$FGLAB'"}' | grep "HYP" > $TEMP1
    endif
    foreach TRAN ( `awk '{printf "%.1lf\n",substr($2,1,6)}' $TEMP1 | sort -n | uniq | awk '{if (substr($1,1,4)=="1910") print $1; else print substr($1,1,4)}'`)
	awk '{if ($1=="'$ION'" && substr($2,1,length("'$TRAN'"))=="'$TRAN'") exit; else print $0}' $OUTNOISO > $TEMP2
	@ TRANLINE = `wc $TEMP2 | awk '{print $1}'`
	awk '{if (substr($2,1,length("'$TRAN'"))=="'$TRAN'") print $0}' $TEMP1 >> $TEMP2
	awk 'NR > '$TRANLINE' {if ($1!="'$ION'" || substr($2,1,length("'$TRAN'"))!="'$TRAN'") print $0}' $OUTNOISO >> $TEMP2
	mv -f $TEMP2 $OUTNOISO
    end
end

rm -f $TEMP1 $TEMP2
touch $TEMP1 $TEMP2

awk '{if ($1=="FeI") { \
if (substr($2,1,6)=="2967.7") {printf "FeI   2984.44\n%s\n",$0} \
else if (substr($2,1,6)=="3720.9") {printf "FeI   3861.00\n%s\nFeI   3441.59\n",$0} \
else print $0} else print $0}' $VPATOM > $OUTISO
foreach ION ( NaI MgI MgII AlII AlIII SiII SiIV CaII TiII CrII MnII FeI FeII NiII ZnII )
    set CSVFILE = `echo $INPREFIX"_"$ION$INSUFFIX`
    awk -f MMatomdat_csv2atom.awk $CSVFILE | awk '{print $0,"'$WQLAB'","'$FGLAB'"}' | grep "ISO\|HYP\|ALL" > $TEMP1
    foreach TRAN ( `awk '{printf "%.1lf\n",substr($2,1,6)}' $TEMP1 | sort -n | uniq | awk '{if (substr($1,1,4)=="1910") print $1; else print substr($1,1,4)}'`)
	awk '{if ($1=="'$ION'" && substr($2,1,length("'$TRAN'"))=="'$TRAN'") exit; else print $0}' $OUTISO > $TEMP2
	@ TRANLINE = `wc $TEMP2 | awk '{print $1}'`
	awk '{if (substr($2,1,length("'$TRAN'"))=="'$TRAN'") print $0}' $TEMP1 >> $TEMP2
	awk 'NR > '$TRANLINE' {if ($1!="'$ION'" || substr($2,1,length("'$TRAN'"))!="'$TRAN'") print $0}' $OUTISO >> $TEMP2
	mv -f $TEMP2 $OUTISO
    end
end

rm -f $TEMP1 $TEMP2

exit

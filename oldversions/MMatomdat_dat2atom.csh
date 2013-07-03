#!/bin/tcsh

set IN = 'MMatomdat.dat'
set VPATOM = 'atom_vpfit10_270911_core.dat'
set OUTISO = 'MMatomdat_atom.dat' ; /bin/rm -f $OUTISO ; touch $OUTISO
set OUTNOISO = 'MMatomdat_atom_noiso.dat' ; /bin/rm -f $OUTNOISO ; touch $OUTNOISO
set TEMP1 = 'MMatomdat_dat2atom_temp1.dat' ; /bin/rm -f $TEMP1 ; touch $TEMP1
set TEMP2 = 'MMatomdat_dat2atom_temp2.dat' ; /bin/rm -f $TEMP2 ; touch $TEMP2
set WQLAB = 'w,q:Murphy_28Sep11'
set FGLAB = 'f,g:M03'

awk -f MMatomdat_dat2atom.awk $IN | grep "all\|noiso" >> $TEMP1
set ELEMEN = `awk '{print substr($1,1,2)}' $TEMP1`
set IONLEV = `awk '{print $1}' $TEMP1`
set WAVLAB = `awk '{print $2}' $TEMP1`
set WAVLEN = `awk '{print $3}' $TEMP1`
set OSCSTR = `awk '{print $4}' $TEMP1`
set QCOEFF = `awk '{print $5}' $TEMP1`
@ i = 0
foreach TRAN ( $WAVLEN )
  @ i = $i + 1
  if ( $i == 1 ) then
    /bin/cp -f $VPATOM $TEMP1
  endif
  @ k = `grep -n "$IONLEV[$i] " $TEMP1 | grep " $WAVLAB[$i]" | awk -F ':' '{print $1}'`
  set GAM = `grep "$IONLEV[$i] " $TEMP1 | grep " $WAVLAB[$i]" | awk '{print $4}'`
  set MASS = `grep "$ELEMEN[$i]" $TEMP1 | head -1 | awk '{print $5}'`
  awk 'NR < '$k' {print $0}' $TEMP1 > $TEMP2
  echo "$IONLEV[$i] $WAVLEN[$i] $OSCSTR[$i] $GAM $MASS $QCOEFF[$i] $WQLAB $FGLAB" | awk '{printf "%-5s %s %s %s %s %s %s %s\n",$1,$2,$3,$4,$5,$6,$7,$8}' >> $TEMP2
  awk 'NR > '$k' {print $0}' $TEMP1 >> $TEMP2
  /bin/mv -f $TEMP2 $TEMP1
end
/bin/mv -f $TEMP1 $OUTNOISO
/bin/rm -f $TEMP1 $TEMP2;

touch $TEMP1; touch $TEMP2

awk -f MMatomdat_dat2atom.awk $IN | grep -v "all" >> $TEMP1
set ELEMEN = `awk '{print substr($1,1,2)}' $TEMP1`
set IONLEV = `awk '{print $1}' $TEMP1`
set WAVLAB = `awk '{print $2}' $TEMP1`
set WAVLEN = `awk '{print $3}' $TEMP1`
set OSCSTR = `awk '{print $4}' $TEMP1`
set QCOEFF = `awk '{print $5}' $TEMP1`
set ISOLAB = `awk '{if (index($6,"noiso")>0) sub("noiso","all",$6); print $6}' $TEMP1`
@ i = 0
foreach TRAN ( $WAVLEN )
  @ j = $i
  @ i = $i + 1
  if ( $i == 1 ) then
    @ j = 1
    /bin/cp -f $VPATOM $TEMP1
  endif
  if ( $i == 1 || ( ($IONLEV[$i] != $IONLEV[$j]) || ($WAVLAB[$i] != $WAVLAB[$j]) ) ) then
    if ( $i > 1 ) then
      awk 'NR > '$k' {print $0}' $TEMP1 >> $TEMP2
      /bin/mv -f $TEMP2 $TEMP1
    endif
    @ k = `grep -n "$IONLEV[$i] " $TEMP1 | grep " $WAVLAB[$i]" | awk -F ':' '{print $1}'`
    set GAM = `grep "$IONLEV[$i] " $TEMP1 | grep " $WAVLAB[$i]" | awk '{print $4}'`
    set MASS = `grep "$ELEMEN[$i]" $TEMP1 | head -1 | awk '{print $5}'`
    awk 'NR < '$k' {print $0}' $TEMP1 > $TEMP2
  endif
  echo "$IONLEV[$i] $WAVLEN[$i] $OSCSTR[$i] $GAM $MASS $QCOEFF[$i] $ISOLAB[$i] $WQLAB $FGLAB" | awk '{printf "%-5s %s %s %s %s %s %s %s %s\n",$1,$2,$3,$4,$5,$6,$7,$8,$9}' >> $TEMP2
end    
if ( `wc $TEMP2 | awk '{print $1}'` > 0 ) then
  awk 'NR > '$k' {print $0}' $TEMP1 >> $TEMP2
  /bin/mv -f $TEMP2 $TEMP1
endif
/bin/mv -f $TEMP1 $OUTISO
/bin/rm -f $TEMP1 $TEMP2

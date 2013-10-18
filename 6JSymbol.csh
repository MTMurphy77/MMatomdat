#!/bin/tcsh

awk 'NR > 1 { I=$1; Jlo=$2; Flo=$3; Jhi=$4; Fhi=$5; print "6J",Jlo,Flo,I,Fhi,Jhi,1}' 6JSymbol_in.dat | sed -e 's/0\.5/1\/2/g' -e 's/1\.5/3\/2/g' -e 's/2\.5/5\/2/g' -e 's/3\.5/7\/2/g' > rrf.dat
@ NTRAN = `wc rrf.dat | awk '{print $1}'`
@ NTRANp1 = $NTRAN + 1
rrfcalc < rrf.dat | tail -$NTRANp1 | head -$NTRAN | sed 's/: //' | awk '{print "="$1}' > 6JSymbol_out.dat

\rm -f rrf.dat

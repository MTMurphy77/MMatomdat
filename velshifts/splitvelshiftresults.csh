#!/bin/tcsh

awk 'NR > 1 {print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11}' velshifts_v_11.2-17.0.dat > velshifts_11.2-17.0_Mg-Si.dat
awk 'NR > 1 {print $1,$19,$20,$21,$22,$23,$24,$27,$28,$33,$34,$35}' velshifts_v_11.2-17.0.dat > velshifts_11.2-17.0_Cr-Zn.dat

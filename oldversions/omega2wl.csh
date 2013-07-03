#!/bin/tcsh

awk ' NR > 1 && NR <= 93 { omega=$4; if ($1 != "----") ion=$1; if ($2 != "----") lab=$2; if ($3 != "----") mass=$3; if ($5 != "----") { eomega=$5; lambda=1.e8/omega; elambda=lambda*eomega/omega; printf "%-5s %-4s %-5s %-12s %-8s %11.6lf %8.6lf\n",ion,lab,mass,omega,eomega,lambda,elambda } else { lambda=1.e8/omega; printf "%-5s %-4s %-5s %-12s          %11.6lf         \n",ion,lab,mass,omega,lambda}} ' MMatomdat.dat

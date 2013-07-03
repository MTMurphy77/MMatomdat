#!/bin/tcsh

if ($1 == "") then
  echo "FATAL ERROR: $0 must be run with INPUT atom.dat file"
  echo "             as first argument"
endif

if ($2 == "") then
  echo "FATAL ERROR: $0 must be run with OUTPUT atom.dat file"
  echo "             as second argument"
endif

awk -f MMatomdat_atom2spabs.awk $1 > $2

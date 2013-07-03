#!/bin/tcsh

#echo "# Line       lambda[A]       d(lambda)[A] f             K              Source" > H2.dat
#awk 'NR > 13 { name=substr($0,1,9); j=substr($0,8,1); k=$4; l=$5*10.0; dl=$6*10.0; s=$7; f=$8; printf "%-9s    %12.7lf    %9.7lf    %11.9lf   %11.8lf    %-2s\n",name,l,dl,f,k,s}' Kcoefs_labwavelengths_H2.txt >> H2.dat

echo "#Q\n??     1000.000  0.416400  6.265E8  1.00\n<<     1215.6701  0.416400  6.265E8  1.00\n>>     1215.6701  0.416400  6.265E8  1.00\n<>     1215.6701  0.416400  6.265E8  1.00\n__     1215.6701  0.416400  6.265E8  1.00\nH I   1215.6701000 0.416400  6.265E8 1.00794" > atom_H2.dat
awk 'NR > 13 { name=substr($0,1,9); j=substr($0,8,1); k=$4; l=$5*10.0; dl=$6*10.0; s=$7; f=$8; printf "H2J%1d %13.7lf %11.9lf 2.000e7  2.01588 %11.8lf  ! %-9s   %-2s\n",j,l,f,k,name,s}' Kcoefs_labwavelengths_H2.txt | sort -r -n -k 2 >> atom_H2.dat
echo "end   0000.0000000 0.000000  0.00000   0.000 Terminator" >> atom_H2.dat

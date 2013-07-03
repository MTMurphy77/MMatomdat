#!/bin/tcsh

# Generate synthetic spectra with one velocity component using all the
# isotopic and hyperfine structure of all MM transitions, varying the
# column density of Fe (and other lines in accordance with a solar
# abundance pattern) and fitting the spectra without using the
# isotopic/hyperfine structures to derive the consequent velocity
# shifts.

set VPFITEXEC = 'vpfit9.5'
set VELDISP = '1.3' # km/s per pixel.
set WLSTART = '1384.0' # Angstroms
set WLEND = '3391.0' # Angstroms
set SNR = '10000.0' # Signal-to-noise ratio (though no noise is actually added)
set RESOLPOW = '75000.0' # Resolving power
set BPARAM = '2.5'
set NFEIILOW = '15.75'
set NFEIIHI = '15.75'
set DNFEII = '0.05'
set INITVWIDTH = '500.0'
set FITVWIDTH = '50.0'
set ATDATISO = 'MM_VPFIT_2012-06-06.dat'
set ATDATNOISO = 'MM_VPFIT_2012-06-06_noiso.dat'
set RELCOLDENFILE = 'relative_column_densities.dat'

set RESULTSFILE_V = 'velshifts_v.dat'; rm -f $RESULTSFILE_V; touch $RESULTSFILE_V
set RESULTSFILE_N = 'velshifts_n.dat'; rm -f $RESULTSFILE_N; touch $RESULTSFILE_N
set RESULTSFILE_B = 'velshifts_b.dat'; rm -f $RESULTSFILE_B; touch $RESULTSFILE_B
set INITDATFILE = 'initial.dat'; rm -f $INITDATFILE; touch $INITDATFILE
set INITF13FILE = 'initial.f13'; rm -f $INITF13FILE; touch $INITF13FILE
set VPFITCOMFILE = 'vpfit.com'; rm -f $VPFITCOMFILE; touch $VPFITCOMFILE
set F13FILE = 'fort.13'
set F17FILE = 'fort.17'
set F18FILE = 'fort.18'
set F26FILE = 'fort.26'

# Determine list of transitions and ions
# BUG NOTE: This only handles two-letter elements
set TRANSLIST = `grep '[CH][MY][P]' $ATDATNOISO | awk '{wl=substr($2,1,4); if (wl=="1910") wl=substr($2,1,6); print wl}'`
@ NTRANSLIST = `echo "$TRANSLIST" | wc | awk '{print $2}'`
set WLLABLIST = `grep '[CH][MY][P]' $ATDATNOISO | awk '{print $2}'`
set IONLIST = `grep '[CH][MY][P]' $ATDATNOISO | awk '{print $1}'`
set IONS = `grep '[CH][MY][P]' $ATDATNOISO | awk '{print $1}' | sort | uniq`

# Create header line for velocity results file
echo -n "# NFeII" >> $RESULTSFILE_V
@ i = 0
foreach TRAN ( $TRANSLIST )
    @ i = $i + 1
    echo "$IONLIST[$i]$TRANSLIST[$i]" | awk '{printf " %-10s",$1}' >> $RESULTSFILE_V
end
echo "" >> $RESULTSFILE_V
# Create headers for N and b results files
echo -n "# NFeII" >> $RESULTSFILE_N
echo -n "# NFeII" >> $RESULTSFILE_B
@ i = 0
foreach ION ( $IONS )
    @ i = $i + 1
    echo "$ION" | awk '{printf " %-10s",$1}' >> $RESULTSFILE_N
    echo "$ION" | awk '{printf " %-10s",$1}' >> $RESULTSFILE_B
end
echo "" >> $RESULTSFILE_N
echo "" >> $RESULTSFILE_B

# First phase is to generate a unity spectrum covering the correct
# wavelengths for all transitions.
echo "$WLSTART $WLEND $VELDISP $SNR" | awk '{ws=$1; we=$2; vd=$3; snr=$4; err=1.0/snr; lvd=log(1.0+vd/299792.458)/log(10.0); wl=ws; i=0; while (wl<we) {wl=ws*10.0^(i*lvd); i=i+1; printf "%13.8lf  1.0  %12.8lf\n",wl,err}}' >> $INITDATFILE

# Loop over the range of FeII column densities to be used, simulating
# spectra for each value and then fitting those synthetic spectra
set NFEIILIST = `echo "$NFEIILOW $NFEIIHI $DNFEII" | awk '{nfeii=$1-$3; while (nfeii<$2-0.00001) {nfeii=nfeii+$3; printf "%lf ",nfeii}}'`
foreach NFEII ( $NFEIILIST )
    echo -n "Log FeII column density = $NFEII."
    # Create a fort.13 file for this column density in FeII
    rm -f $INITF13FILE; touch $INITF13FILE
    echo "   *" >> $INITF13FILE
    @ i = 0
    foreach TRAN ( $TRANSLIST )
	@ i = $i + 1
	echo "$IONLIST[$i] $TRANSLIST[$i] $WLLABLIST[$i] $INITVWIDTH $RESOLPOW $INITDATFILE" | awk '{ion=$1; tran=$2; wl=$3; dv=$4; R=$5; datfile=$6; c=299792.458; vsig=c/(R*2.0*sqrt(2.0*log(2.0))); printf " %-s   1  %7.3lf  %7.3lf vsig=%6.4lf ! %-s%-s\n",datfile,wl*(1.0-0.5*dv/c),wl*(1.0+0.5*dv/c),vsig,ion,tran}' >> $INITF13FILE
    end
    echo "  *" >> $INITF13FILE
    foreach i ( $IONS )
	echo "$i $NFEII $BPARAM" | awk 'BEGIN {while ( getline < "'$RELCOLDENFILE'" > 0 ) relcol[$1]=$2 } {ion=$1; nfeii=$2; bparam=$3; printf "  %-5s   %9.6lf    0.000000000AA   %8.5lf      0.0000E-00QA    0.00    0.00 0.00\n",ion,nfeii+relcol[ion],bparam}' >> $INITF13FILE
    end
    # Construct the command to run VPFIT and output the spectrum to the fort.17 ASCII file
    set VPFITCOM = 'printf "d\n\n\n'$INITF13FILE'\n\n\nas\n\n/NULL\n\n'
    @ i = 1
    while ( $i < $NTRANSLIST )
	@ i = $i + 1
	set VPFITCOM = "${VPFITCOM}\n\n\n"
    end
    set VPFITCOM = "${VPFITCOM}\n\nn\nn\n"'"'
    echo "$VPFITCOM | $VPFITEXEC > /dev/null" > $VPFITCOMFILE
    # Set atomic data file to be one with all the isotopic and hyperfine structures
    rm -f atom.dat; ln -s $ATDATISO atom.dat
    # Run VPFIT to create the fort.17 ASCII file
    echo -n " Creating ISO/HYP spectrum."
    source $VPFITCOMFILE
    # Find the chunck of simulated spectrum for each transition in the fort.17 file
    set SLINES = `grep -n "! -------------------------" $F17FILE | awk -F ':' '{print $1+1}'`
    set ELINES = `grep -n "!  ---- tick mark positions for above ----" $F17FILE | awk -F ':' '{print $1-1}'`
    # Construct the fitting fort.13 file and data chunk for each transition.
    rm -f $F13FILE; touch $F13FILE
    echo "   *" >> $F13FILE
    @ i = 0
    foreach TRAN ( $TRANSLIST )
	@ i = $i + 1
	echo "$IONLIST[$i] $TRANSLIST[$i] $WLLABLIST[$i] $FITVWIDTH $RESOLPOW" | awk '{ion=$1; tran=$2; wl=$3; dv=$4; R=$5; c=299792.458; vsig=c/(R*2.0*sqrt(2.0*log(2.0))); printf " %-s%-s   1  %7.3lf  %7.3lf vsig=%6.4lf ! %-s%-s\n",ion,tran,wl*(1.0-0.5*dv/c),wl*(1.0+0.5*dv/c),vsig,ion,tran}' >> $F13FILE
	set TRANFILENAME = "$IONLIST[$i]$TRANSLIST[$i]"; rm -f $TRANFILENAME; touch $TRANFILENAME
	printline $F17FILE $SLINES[$i] $ELINES[$i] | awk '{print $1,$4,$3}' >> $TRANFILENAME
    end
    set SLINE = `grep -n '  \*' $INITF13FILE | tail -1 | awk -F ':' '{print $1}'`
    set ELINE = `wc $INITF13FILE | awk '{print $1}'`
    printline $INITF13FILE $SLINE $ELINE >> $F13FILE
    # Add the velocity shift parameter lines to the fort.13 file
    @ i = 0
    foreach TRAN ( $TRANSLIST )
	@ i = $i + 1
	echo "$WLLABLIST[$i]" | awk '{wl=$1; zlya=wl/1215.6701-1.0; printf "  >>      1.00000SH    %11.9lfSZ    0.0000       0.0000E-00QA    0.00    0.00 0.00\n",zlya}' >> $F13FILE
    end
    # Construct the command to run VPFIT
    set VPFITCOM = 'printf "f\nil\ncs\n2.e-6 10000.0 2.e-6\nn\n0.002\nb\n0.01\n\n\n'$F13FILE'\nn\nn\n\n"'
    # Set atomic data file to be one without the isotopic and hyperfine structures
    rm -f atom.dat; ln -s $ATDATNOISO atom.dat
    echo "$VPFITCOM | $VPFITEXEC > /dev/null" > $VPFITCOMFILE
    # Run VPFIT
    echo " Fitting w/o ISO/HYP structures."
    source $VPFITCOMFILE
    # Record velocity shift result for each transition
    set RESULTS = `awk '{if ($1==">>") print $4}' $F26FILE`
    echo "$NFEII $RESULTS" | awk '{printf "%7.4lf",$1; for (i=2; i<=NF; i++) printf " %9.5lf ",$i; printf "\n"}' >> $RESULTSFILE_V
    # Record column density result for each ion
    set RESULTS = `awk '{if (index($1,"I")>0) print $6}' $F26FILE`
    echo "$NFEII $RESULTS" | awk '{printf "%7.4lf",$1; for (i=2; i<=NF; i++) printf " %9.6lf ",$i; printf "\n"}' >> $RESULTSFILE_N
    # Record b parameter result for each ion
    set RESULTS = `awk '{if (index($1,"I")>0) print $4}' $F26FILE`
    echo "$NFEII $RESULTS" | awk '{printf "%7.4lf",$1; for (i=2; i<=NF; i++) printf " %9.5lf ",$i; printf "\n"}' >> $RESULTSFILE_B
end

exit

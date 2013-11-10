This directory includes the supplementary information for Murphy & Berengut (2014, MNRAS, submitted).

The master spreadsheet is MMatomdat.ods in OpenDocument format. This is also exported to MMatomdat.xlsx for opening with Microsoft Office-compatible software. See the notes in the MMatomdat.[ods,xlsx] spreadsheet for more details.

Included in this directory is also a series of scripts (AWK and C-Shell) which convert the CSV versions of each of the sheets in MMatomdat.ods into tables which are either useful as input to different quasar absorption analysis codes (e.g. VPFIT), or for visualizing the isotopic/hyperfine structures in velocity space (a la Figures 1-10 in Murphy & Berengut 2014). The commands and sequence for executing these scripts is described below.

Step 1: Export each sheet, corresponding to each ion, from MMatomdat.ods to a CSV file called MMatomdat_ION.csv (e.g. MMatomdat_MgII.csv). Best to use an OpenDocument compatible program for this (e.g. LibreOffice).

Step 2: Run the MMatomdat_csv2atom.csh script. This takes the "atom.dat" file released with VPFIT (the latest version is included here, VPFIT??_atom_YYYY-MM--DD.dat and is read by this script) and replaces the laboratory data for those transitions included in the exported CSV files (one for each ion). This creates two new files, MM_VPFIT_YYYY-MM-DD.dat and MM_VPFIT_YYYY-MM-DD_noiso.dat, with and without the narrow isotopic/hyperfine structures (but including the wide hyperfine structures for AlIII and MnII).
./MMatomdat_csv2atom.csh

Step 3: Run the MMatomdat_atom2spabs.csh script to convert the new VPFIT atomic data file to one compatible with the Voigt profile-producing code called SPABS.
./MMatomdat_atom2spabs.csh MM_VPFIT_[YYYY-MM-DD]_noiso.dat MM_SPABS_[YYYY-MM-DD]_noiso.dat

Step 4: Run the MMatomdat_make_element_CSVs.csh script to combine the ion CSV files into CSV files for each atom.
./MMatomdat_make_element_CSVs.csh

Step 5: Run the MMatomdat_csv2tex.csh script to convert the atom CSV files to LaTeX tables called MM_[Atom]-YYYY-MM-DD.tex.
./MMatomdat_csv2tex.csh

Step 6: Run the MMatomdat_csv2isodat.csh file to export the isotopic/hyperfine structure information into individual ASCII data files in the IHFstruct subdirectory included here. If you then go into that subdirectory you can use the Supermongo script there (iso.sm) to turn these data files into plots like those in Figures 1-8 in Murphy & Berengut (2014).
./MMatomdat_csv2isodat.csh
cd IHFstruct; sm < iso.sm; cd ../

-----
Note: For version 2013-11-10, for production of Murphy:2014, Steps 4-6 were replaced with the following steps to separate the FeI and FeII tables:
\mv -f MMatomdat_FeII.csv tempFeII.csv; \rm -f MMatomdat_Fe.csv
./MMatomdat_make_element_CSVs.csh; ./MMatomdat_csv2tex.csh; ./MMatomdat_csv2isodat.csh
\mv MM_Fe-2013-11-10.tex MM_FeI-2013-11-10.tex; \mv IHFstruct/Fe.dat IHFstruct/FeI.dat
\mv -f tempFeII.csv MMatomdat_FeII.csv

\mv -f MMatomdat_FeI.csv tempFeI.csv; \rm -f MMatomdat_Fe.csv
./MMatomdat_make_element_CSVs.csh; ./MMatomdat_csv2tex.csh; ./MMatomdat_csv2isodat.csh
\mv MM_Fe-2013-11-10.tex MM_FeII-2013-11-10.tex; \mv IHFstruct/Fe.dat IHFstruct/FeII.dat
\mv -f tempFeI.csv MMatomdat_FeI.csv

./MMatomdat_make_element_CSVs.csh; ./MMatomdat_csv2tex.csh; ./MMatomdat_csv2isodat.csh
cd IHFstruct; sm < iso.sm; cd ../
-----


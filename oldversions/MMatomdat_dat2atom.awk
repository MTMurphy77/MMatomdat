BEGIN {}
{
    if (substr($1,1,1)!="#") {
	w=$7;
	if ($1!="----") { ionlev=$1; ion=substr($1,1,2); lev=substr($1,3); }
	if ($2!="----") {
	    iso="all"; wlab=$2; f0=$13; ffrac=1.0; q=$14;
	    if (wlab=="1670" || wlab=="1910.6" || wlab=="1910.9" || wlab=="2249" || wlab=="2260" || ionlev=="NiII") iso="noiso";
	}
	else { iso=substr($3,1); ffrac=$13/100.0; }
	f=f0*ffrac;
	printf "%-5s %-6s %12.7lf %10.8lf %7.1lf %s%s\n",ionlev,wlab,w,f,q,iso,ion;
    }
}
END {}

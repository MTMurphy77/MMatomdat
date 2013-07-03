BEGIN { }
{
    at=substr($0,1,2); io=substr($0,3,4); split(substr($0,7),a," ");
    wl=a[1]; f=a[2]; g=a[3];
    if (at!="# " && at!="! " && at!="H2" && at!="HD" && at!="CO") {
	printf "%-2s%-4s%12.7lf %8.6lf %6.3E\n",at,io,wl,f,g; }
}
END {}

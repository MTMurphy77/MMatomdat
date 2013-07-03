BEGIN {}
{
    if (substr($1,1,1)!="#") {
	if ($1=="----") { ion=""; level=""; levelsca=""; levelscb=""; }
	else { ion=substr($1,1,2); level=tolower(substr($1,3)); levelsca="{\\sc \\,"; levelscb="}"; }
	if ($2=="----") label=""; else label=$2;
	mass=$3;
	wm=$4;
	if ($5=="----") wmer=wm;
	else { a=match($5,/[123456789]/); if (a>0) wmer=wm"("substr($5,a)")"; }
	x=$6;
	wl=$7;
	if ($8=="----") wler=wl;
	else { a=match($8,/[123456789]/); if (a>0) wler=wl"("substr($8,a)")"; }
	if ($9=="----") ground=""; else ground=$9;
	if ($10=="----") upper=""; else upper=$10;
	if ($11=="----") L=""; else L=$11;
	if ($12=="----") IP=""; else IP=$12;
	if ($13=="----") f=""; else f=$13;
	if ($14=="----") q=""; else q=$14;
	if ($15=="----") qer=q;
	else { a=match($15,/[123456789]/); if (a>0) qer=q"("substr($15,a)")"; }
	ref=""; if ($16=="----") ref=",";
	if (match($16,"HannemannS_06a")) ref=ref"a,";
	if (match($16,"SalumbidesE_06a")) ref=ref"b,";
	if (match($16,"BatteigerV_09a")) ref=ref"c,";
	if (match($16,"GriesmannU_00a")) ref=ref"d,";
	if (match($16,"BerengutJ_03a")) ref=ref"e,";
	if (match($16,"Scaled_mass_shift")) ref=ref"f,";
	if (match($16,"RuffoniM_10a")) ref=ref"g,";
	if (match($16,"AldeniusM_06a")) ref=ref"h,";
	if (match($16,"BerengutJ_08a")) ref=ref"i,";
	if (match($16,"BerengutJ_12a")) ref=ref"j,";
	if (match($16,"Blackwell-WhiteheadR_05a")) ref=ref"k,";
	if (match($16,"NaveG_11a")) ref=ref"l,";
	if (match($16,"PorsevS_09a")) ref=ref"m,";
	if (match($16,"G.~Nave")) ref=ref"n,";
	if (match($16,"PickeringJ_00a")) ref=ref"o,";
	if (match($16,"MatsubaraK_03a")) ref=ref"p,";
	if (match($16,"DixitG_08a")) ref=ref"q,";
	if (match($16,"MatsubaraK_03b")) ref=ref"r,";
	ref=substr(ref,1,length(ref)-1);
	if ($2=="----") printf "\\rowstyle{\\itshape}   && ",ion,levelsca,level,levelscb,label;
	else printf "%-2s%-7s%-3s%-1s & %-6s & ",ion,levelsca,level,levelscb,label;
	printf "%-5s & %-16s & %1d & $%-7s$ & %-16s & $%-42s$ & $%-52s$ & $%-3s$ & %-12s & %-7s & $%-10s$ \\\\\n",
	    mass,wmer,x,ref,wler,ground,upper,L,IP,f,qer;
    }
}
END {}

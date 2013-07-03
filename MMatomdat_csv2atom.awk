# CSV parser for Awk from http://lorance.freeshell.org/csv
function csv_parse(string,csv,sep,quote,escape,newline,trim, fields,pos,strtrim) {
    if (length(string) == 0) return 0
    string = sep string
    fields = 0
    while (length(string) > 0) {
        if (trim && substr(string, 2, 1) == " ") {
            if (length(string) == 1) return fields
            string = substr(string, 2)
            continue
        }
        strtrim = 0
        if (substr(string, 2, 1) == quote) {
            pos = 2
            do {
                pos++
                if (pos != length(string) &&
                    substr(string, pos, 1) == escape &&
                    index(quote escape, substr(string, pos + 1, 1)) != 0) {
                    string = substr(string, 1, pos - 1) substr(string, pos + 1)
                } else if (substr(string, pos, 1) == quote) {
                    strtrim = 1
                } else if (pos >= length(string)) {
                    if (newline == -1) {
                        return -1
                    } else if (newline) {
                        if (getline == -1) return -4
                        string = string newline $0
                    }
                }
            } while (pos < length(string) && strtrim == 0)
            if (strtrim == 0) {
                return -3
            }
        } else {
            if (length(string) == 1 || substr(string, 2, 1) == sep) {
                fields++
                csv[fields] = ""
                if (length(string) == 1) return fields
                string = substr(string, 2)
                continue
            }
            pos = index(substr(string, 2), sep)
            if (pos == 0) {
                fields++
                csv[fields] = substr(string, 2)
                return fields
            }
        }
        if (trim && pos != (length(string) + strtrim) && substr(string, pos + strtrim, 1) == " ") {
            trim = strtrim
            while (pos < length(string) && substr(string, pos + trim, 1) == " ") {
                trim++
            }
            string = substr(string, 1, pos + strtrim - 1) substr(string,  pos + trim)
            if (!strtrim) {
                pos -= trim
            }
        }
        if ((pos != length(string) && substr(string, pos + 1, 1) != sep)) {
            return -4
        }
        fields++
        csv[fields] = substr(string, 2 + strtrim, pos - (1 + strtrim * 2))
        if (pos == length(string)) {
            return fields
        } else {
            string = substr(string, pos + 1)
        }
    }
    return fields
}
function csv_create (csv,fields,sep,quote,escape,level, field,pos,string) {
    sep     = (sep ? sep : ",")
    quote   = (quote ? quote : "\"")
    escape  = (escape ? escape : "\"")
    level   = (level ? level : 0)
    string = ""
    for (pos = 1; pos <= fields; pos++) {
        field = csv[pos]
        if (field) {
            if (level == 0) {
                string = string csv_escape_string(field, quote, escape, quote escape)
            } else if ((level >= 2) ||
                       (level == 1 && field !~ /^-*[0-9.][0-9.]*$/)) {
                string = string quote csv_escape_string(field, "", escape, quote escape) quote
            } else {
                string = string field
            }
        } else if (level == 3) {
            string = string quote quote
        }
        if (pos < fields) string = string sep
    }
    return string
}
function csv_err (number) {
    if (number == -1) {
        return "More data expected."
    } else if (number == -2) {
        return "Unable to read the next line."
    } else if (number == -3) {
        return "Missing end quote."
    } else if (number == -4) {
        return "Missing separator."
    }
}
function csv_escape_string (string,quote,escape,special, pos,prev,char,csv) {
    prev = 1
    csv = ""
    for (pos = 1; pos < length(string) + 1; pos++) {
        char = substr(string, pos, 1)
        if (index(special, char) > 0) {
            if (pos == 1) {
                csv = escape char
            } else {
                csv = csv substr(string, prev, (pos - prev)) escape char
            }
            prev = pos + 1
        }
    }
    if (prev != pos) {
        csv = csv substr(string, prev)
    }
    if (quote && string != csv) {
        return quote csv quote
    } else {
        return csv
    }
}

BEGIN {}
{
    nfields=csv_parse($0,csv,",","\"","\"","\\n",1);
    if (nfields<0) {
        printf "ERROR: %d (%s) -> %s\n",nfields,csv_err(nfields),$0;
    }
    if (csv[1]=="Summary") summary=0;
    if (csv[1]=="Ion" && summary==0) summary=1;
    if (csv[1]=="END") summary=-1;
    if (summary==1 && csv[1]!="Ion") {
	type=csv[3]; split(csv[4],A,";"); w=csv[9]; ffrac=csv[17]; isolabel="";
	if (type=="CMP" || type=="ALL") {
	    if (csv[1]!="") ion=csv[1];
	    tran=csv[2]; A0=A[1]; f0=ffrac; ffrac=1.0; gamma=csv[18]; q=csv[19];
        }
	else { ffrac=ffrac/100.0; if (substr(type,1,3)=="ISO") A0=A[2]; isolabel=A[1]; }
	f=f0*ffrac;
	printf "%-5s %12.7lf %10.8lf %7.3E %8.4lf %8.1lf %s%s\n",ion,w,f,gamma,A0,q,isolabel,type;
    }
}
END {}

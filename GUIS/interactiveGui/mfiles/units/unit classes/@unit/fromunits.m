function newval=fromunits(un,oldval)
con=getconverter(un);
newval=fromunits(con,oldval);

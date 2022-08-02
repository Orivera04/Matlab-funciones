function newval=tounits(un,oldval)
mlt=un.multiplier;
ad=un.add;
newval=(oldval*mlt)+ad;

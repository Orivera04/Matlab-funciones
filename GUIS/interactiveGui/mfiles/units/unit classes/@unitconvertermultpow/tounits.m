function newval=tounits(un,oldval)
mlt=un.multiplier;
pwr=un.power;
newval=power(oldval,pwr)/mlt;
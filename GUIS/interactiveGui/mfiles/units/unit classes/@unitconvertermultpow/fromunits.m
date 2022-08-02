function newval=fromunits(un,oldval)
mlt=un.multiplier;
pwr=un.power;
newval=power(oldval*mlt,pwr);
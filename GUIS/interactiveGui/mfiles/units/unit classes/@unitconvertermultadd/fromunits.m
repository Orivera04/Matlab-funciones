function newval=fromunits(un,oldval)
mlt=un.multiplier;
ad=un.add;
% newval=(oldval*mlt)+ad;
newval=(oldval-ad)/mlt;

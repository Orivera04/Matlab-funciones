a=7;
b=3;
c=45;
d=8;
e=4;
f=3;

af=rise2xy([-e,f,d,a,0]);
reaction=threevector(af,[0,0,0;DR(90),0,0;DR(180-45),a+b,0]);
CableMagnitude=mag(reaction(3,:))

function par=normal_s(perc1,perc2)
%
% NORMAL_S Finds normal distribution which matches two percentiles.
%	PAR=NORMAL_S(PERC1,PERC2) returns a vector PAR which contains the mean 
%	and standard deviation of the matching normal distribution, where
%	PERC1 is the vector containing the probability and the value for the
%	first percentile, and PERC2 contains the probability and value for the
%	second percentile.

p1=perc1(1); m1=perc1(2); p2=perc2(1); m2=perc2(2);
z1=phiinv(p1); z2=phiinv(p2);

h0=(m1-m2)/(z1-z2); m0=m1-h0*z1;
par=[m0 h0];

function val=phiinv(x)
val=sqrt(2)*erfinv(2*x-1);



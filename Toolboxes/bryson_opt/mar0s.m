function sp=mar0s(t,s,flg,tn,ben,sn,K)
% Subroutine for Pb. 8.5.9;                               8/21/02
%
r=s(1); u=s(2); v=s(3); sn1=interp1(tn,sn,t); K1=interp1(tn,K,t);
be1=interp1(tn,ben,t); be=be1-K1*(s-sn1'); T=.1405; mdot=.07489;
a=T/(1-mdot*t); sp=[u; v^2/r-1/r^2+a*sin(be); -u*v/r+a*cos(be)];                 
	
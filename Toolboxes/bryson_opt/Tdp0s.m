function sp=tdp0s(t,s)
% Subroutine for Pb. 8.5.8;        7/10/02
%
global tn sn thn K; u=s(1); v=s(2); 
sn1=interp1(tn,sn,t); K1=interp1(tn,K,t);
th1=interp1(tn,thn,t); th=th1-K1*(s-sn1');
co=cos(th); si=sin(th); 
sp=[co si v u]';

	
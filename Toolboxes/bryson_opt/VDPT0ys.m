function sp=vdpt0ys(t,s)                      
% Subroutine for Pb. 8.7.5;       7/10/02
%
global a tn sn ufn K; V=s(1);
sn1=interp1(tn,sn,t); K1=interp1(tn,K,t);
uf1=interp1(tn,ufn,t);
ga=uf1-K1*(s-sn1'); co=cos(ga); si=sin(ga); 
sp=[a+si; V*co; V*si];       



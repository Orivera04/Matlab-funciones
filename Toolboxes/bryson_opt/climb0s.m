function sp=climb0s(t,s)                      
% Subroutine for Pb. 8.5.23a;         8/13/02
%
global tn sn aln K; V=s(1); ga=s(2);   
sn1=interp1(tn,sn,t); K1=interp1(tn,K,t);
al1=interp1(tn,aln,t); al=al1-K1*(s-sn1'); 
alm=1/12; eta=.5; T=.2; si=sin(ga); co=cos(ga); 
sp=[T-eta*(al^2+alm^2)*V^2-si; V*al-co/V; V*si; V*co];



function sp=climbe(t,s)               
% Subroutine for Pb. 3.6.23f,b; max altitude climb, A/C with parabolic
% lift-drag polar; al=alpha;  s=[V ga h lv lg lh]';       2/92, 9/5/02  
% 
alm=1/12; eta=.5; T=.2; V=s(1); ga=s(2); h=s(3); lv=s(4); lg=s(5);
lh=s(6); la=[lv lg lh]'; si=sin(ga); co=cos(ga); al=lg/(2*eta*V*lv);
f=[T-eta*(al^2+alm^2)*V^2-si; V*al-co/V; V*si];
fs=[-2*V*eta*(al^2+alm^2) -co 0; al+co/V^2 si/V 0; si V*co 0]; 
sp=[f; -fs'*la];  


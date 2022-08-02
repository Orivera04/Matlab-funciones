function sp=climbxe(t,s)               
% Subroutine for Pb. 3.5.23x; max altitude climb with spec. xf; A/C 
% with parabolic lift-drag polar; s=[V,ga,h,lv,lg,lh]';  
%                                                 2/92, 11/96, 6/23/98  
% 
alm=1/12; eta=.5; T=.2; V=s(1); ga=s(2); h=s(3); lv=s(4); lg=s(5);
lh=s(6); la=[lv lg lh]'; si=sin(ga); c=cos(ga); al=lg/(2*eta*V*lv);
fs=[-T/(V^2*c)-eta*(al^2+alm^2)/c+si/(V^2*c)...
      si*T/(V*c^2)-V*eta*(al^2+alm^2)*si/c^2-1/(V*c^2) 0;...
     2/V^3 al*si/c^2 0; 0 1/c^2 0];
f=[T/(V*c)-eta*(al^2+alm^2)*V/c-si/(V*c); al/c-1/V^2; si/c];
sp=[f; -fs'*la];  

		 	
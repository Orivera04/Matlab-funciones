function yp=climbte(t,y)                           
% Subroutine for Pb. 4.6.23f,b, min time climb A/C w. parab. lift-drag 
% polar using FOPTF; s=[V,gamma,h,x]'; al = control; (h,x) in l,
% V in sqrt(g*l), t in sqrt(l/g);	                     4/97, 9/14/98
%
alm=1/12; eta=.5; T=.2; V=y(1); ga=y(2); h=y(3); x=y(4); lv=y(5);
lg=y(6); lh=y(7); lx=y(8); la=[lv lg lh lx]'; si=sin(ga); c=cos(ga);
al=lg/(2*eta*V*lv);  
f=[T-eta*(al^2+alm^2)*V^2-si; V*al-c/V; V*si; V*c];
fs=[-2*V*eta*(al^2+alm^2) -c 0 0;...
      al+c/V^2  si/V 0 0; si  V*c 0 0; c -V*si 0 0];
yp=[f; -fs'*la];
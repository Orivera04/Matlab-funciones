function yp=gldce(t,y)               
% Subroutine for Pb. 3.6.22f,b; y=[V ga h lv lg lh]';     8/14/02  
% 
alm=1/12; eta=.5; V=y(1); ga=y(2); h=y(3); lv=y(4); lg=y(5);
lh=y(6); la=[lv lg lh]'; si=sin(ga); co=cos(ga);
al=lg/(2*eta*V*lv); f=[-eta*(al^2+alm^2)*V^2-si V*al-co/V V*si]';
fs=[-2*V*eta*(al^2+alm^2) -co 0; al+co/V^2 si/V 0; si V*co 0]; 
yp=[f; -fs'*la];  

    
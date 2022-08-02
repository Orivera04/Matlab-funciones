function yp=gldte(t,y) 
% Subroutine for Pb. 4.6.22f,b; max tf for spec. (Vf,gaf,hf) for
% glider; s=[V,ga,h]'; h in l, V in sqrt(g*l), t in sqrt(l/g),  
% l=2m/(rho*S*Cla), alm = sqrt(Cdo/(eta*Cla));      4/97, 9/14/98
%
alm=1/12; eta=.5; V=y(1); ga=y(2); h=y(3); lv=y(4); lg=y(5); lh=y(6);
la=[lv lg lh]'; si=sin(ga); c=cos(ga); al=lg/(2*eta*V*lv); 
f=[-eta*(al^2+alm^2)*V^2-si; al*V-c/V; V*si];
fs=[-2*V*eta*(al^2+alm^2) -c  0;	al+c/V^2 si/V 0; si V*c 0];
yp=[f; -fs'*la];
	
	


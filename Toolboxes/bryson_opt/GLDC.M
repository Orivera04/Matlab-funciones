function [f1,f2]=gldc(al,s,t,flg) 
% Subroutine for Pb. 3.4.22a & 3.6.22f,b; min altitude drop of a glider
% with (Vf,gaf) specified; s=[V ga h]'; h in l, V in sqrt(g*l), t in 
% sqrt(l/g), l=2m/(rho*S*Cla), alm=sqrt(Cdo/(eta*Cla));   2/93, 8/14/02
%
alm=1/12; eta=.5; Vf=4; V=s(1); ga=s(2); h=s(3); si=sin(ga); co=cos(ga); 
if flg==1
    f1=[-eta*(al^2+alm^2)*V^2-si; al*V-co/V; V*si];
elseif flg==2
    f1=[h; V-Vf; ga];
    f2=[0 0 1; 1 0 0; 0 1 0];
elseif flg==3
    f1=[-2*V*eta*(al^2+alm^2) -co 0; al+co/V^2 si/V 0; si V*co 0];
    f2=[-2*V^2*eta*al V 0]';
end


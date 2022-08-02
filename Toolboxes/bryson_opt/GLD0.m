function [f1,f2,f3,f4,f5]=gld0(al,s,t,flg) 
% Subroutine for Pb. 2.7.22a & 8.5.22a;            8/11/02
%
alm=1/12; eta=.5; Vf=4; V=s(1); ga=s(2); h=s(3); 
si=sin(ga); co=cos(ga); sv=1e3; sg=sv; b=eta*(al^2+alm^2);
if flg==1
    f1=[-b*V^2-si; al*V-co/V; V*si];
elseif flg==2
    f1=[h-sv*(V-Vf)^2/2-sg*ga^2/2]; 
    f2=[-sv*(V-Vf) -sg*ga 1];
    f3=diag([-sv -sg 0]);
elseif flg==3
    f1=[-2*V*b -co 0; al+co/V^2 si/V 0; si V*co 0]; 
    f2=[-2*V^2*eta*al V 0]';
    f3=[-2*b 0 0; 0 si 0; 0 0 0; ...
        -2*co/V^3 -si/V^2 0; -si/V^2 co/V 0; 0 0 0; ...
        0 co 0; co -V*si 0; 0 0 0];
    f4=[-4*V*eta*al 1 0; 0 0 0; 0 0 0];
    f5=[-2*V^2*eta 0 0]';
end


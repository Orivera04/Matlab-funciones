function [f1,f2,f3,f4,f5]=climb0(u,s,t,flg)                           
% Subroutine for Pbs. 2.7.23a & 8.5.23a;, max altitude climb, A/C w.
% parabolic lift-drag polar; s=[V ga h x]'; u=alpha; h in l, V in 
% sqrt(g*l);                                                 7/21/02
%
alm=1/12; eta=.5; T=.2; V=s(1); ga=s(2); h=s(3); x=s(4); al=u;
si=sin(ga); co=cos(ga); sv=2e2; sga=2e2;
if flg==1
   f1=[T-eta*(al^2+alm^2)*V^2-si; V*al-co/V; V*si; V*co];
elseif flg==2
   f1=[h-sv*(V-7)^2/2-sga*ga^2/2];
   f2=[-sv*(V-7) -sga*ga 1 0];
   f3=diag([-sv -sga 0 0]);
elseif flg==3
   f1=[-2*V*eta*(al^2+alm^2) -co 0 0; al+co/V^2 si/V ...
        0 0; si V*co 0 0; co -V*si 0 0];
   f2=[-2*V^2*eta*al V 0 0]';
   f3=[-2*eta*(al^2+alm^2) 0 0 0; zeros(3,4); ...
       -2*co/V^3 0 0 0; -si/V^2 0 0 0; zeros(2,4); ...
        0 0 0 0; co 0 0 0; zeros(2,4); ...
        0 0 0 0; -si 0 0 0; zeros(2,4)];
   f4=[-4*V*eta*al 0 0 0; 1 0 0 0; zeros(2,4)];
   f5=[-2*V^2*eta 0 0 0]';
end

function [f1,f2,f3]=climbt(u,s,t,flg)                           
% Subroutine for p4_5_23, min time climb, A/C  w. parab. lift-drag
% polar; s=[V ga h]'; u=al; h in l, V in sqrt(g*l);   2/97, 9/5/02
%
Vf=7; hf=11.802; alm=1/12; eta=.5; T=.2; V=s(1); ga=s(2); h=s(3);
al=u; si=sin(ga); co=cos(ga);
if flg==1
    f1=[T-eta*(al^2+alm^2)*V^2-si; V*al-co/V; V*si];
elseif flg==2
    f1=[t; V-Vf; ga; h-hf];
    f2=[0 0 0; 1 0 0; 0 1 0; 0 0 1];
    f3=[1 0 0 0]';
elseif flg==3
    f1=[-2*V*eta*(al^2+alm^2) -co 0; al+co/V^2 si/V 0; si V*co 0];
    f2=[-2*V^2*eta*al V 0]';
end


function [f1,f2]=rbclmb(u,s,t,flg)                           
% Subroutine for Pb. 3.4.23rb; max altitude climb, A/C w. parabolic 
% lift-drag polar; s=[V al q th h x]'; h in l, V in sqrt(g*l); t in
% sqrt(l/g);                                                 9/4/02
%
alm=1/12; eta=.5; T=.2; V0=7; Vf=7; V=s(1); al=s(2); q=s(3); 
th=s(4); h=s(5); ga=th-al; si=sin(ga); co=cos(ga); de=u;
Mv=0; Ma=-250; Mq=-16; Me=Ma;
if flg==1
    f1=[T-eta*(al^2+alm^2)*V^2-si; ...
        q-V*al+co/V-T*al/V; ...
        Mv*(V-V0)+Ma*al+Mq*q+Me*de; ...
        q; V*si; V*co];
elseif flg==2
    f1=[h; V-Vf; ga];  
    f2=[0 0 0 0 1 0; 1 0 0 0 0 0; 0 -1 0 1 0 0];
elseif flg==3
    f1=[-2*V*eta*(al^2+alm^2) co 0 -co 0 0; ... 
        -al-co/V^2+T*al/V^2 -V+si/V-T/V 1 -si/V 0 0;...
        Mv Ma Mq 0 0 0; 0 0 1 0 0 0; ...
        si -V*co 0 V*co 0 0; co V*si 0 -V*si 0 0]; 
    f2=[0 0 Me 0 0 0]';
end

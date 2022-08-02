function yp=rbclmbe(t,y)                           
% Subroutine for Pb. 3.6.23rb; max altitude climb, A/C w. parabolic 
% lift-drag polar; y=[V al q th h x lv lal lq lt lh lx]';     9/5/02
%
alm=1/12; eta=.5; T=.2; V0=7; Vf=7; V=y(1); al=y(2); q=y(3); 
th=y(4); h=y(5); x=y(6); lv=y(7); lal=y(8); lq=y(9); lt=y(10);
lh=y(11); lx=y(12); ga=th-al; si=sin(ga); co=cos(ga); de=u;
Mv=0; Ma=-250; Mq=-16; Me=Ma;
f=[T-eta*(al^2+alm^2)*V^2-si; q-V*al+co/V-T*al/V; ...
        Mv*(V-V0)+Ma*al+Mq*q+Me*de; q; V*si; V*co];
fs=[-2*V*eta*(al^2+alm^2) co 0 -co 0 0; ... 
        -al-co/V^2+T*al/V^2 -V+si/V-T/V 1 -si/V 0 0;...
        Mv Ma Mq 0 0 0; 0 0 1 0 0 0; ...
        si -V*co 0 V*co 0 0; co V*si 0 -V*si 0 0];
la=[lv lal lq lt lh lx]';
yp=[f; -fs'*la];


fu=[0 0 Me 0 0 0]';
    

function [L,f,Ly,fy]=maxclmb1(y)
% Subroutine for Pb. 1.3.11 using POP; max climb angle (flg=1) or max
% limb rate (flg=2); p=[V al ga];                10/96, 1/97, 9/10/98
%
global T flg; ep=2*pi/180; eta=.5; alm=1/12; V=y(1); al=y(2);
ga=y(3); si=sin(ga); c=cos(ga);  
f=[si-T*cos(al+ep)+eta*V^2*(al^2+alm^2); c-T*sin(al+ep)-V^2*al];
fy=[2*eta*V*(al^2+alm^2) 2*eta*V^2*al+T*sin(al+ep)  c;...
         -2*V*al           -V^2-T*cos(al+ep)       -si]; 
if flg==1, L=ga; Ly=[0 0 1];
elseif flg==2, L=V*si;  Ly=[si 0 V*c];
end
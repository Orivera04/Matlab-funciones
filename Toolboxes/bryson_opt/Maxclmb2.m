function [L,f,Ly,fy,Lyy,fyy]=maxclmb2(y)
% Subroutine for Pb. 1.5.11 using POPN; max climb angle (flg=1)
% or max climb rate (flg=2); p=[V al ga];                10/96, 6/24/98
%
global T flg; ep=2*pi/180; eta=.5; alo=1/12; V=y(1); al=y(2); ga=y(3);
sg=sin(ga); cg=cos(ga); ca=cos(al+ep); sa=sin(al+ep);
f=[sg-T*ca+eta*V^2*(al^2+alo^2); cg-T*sa-V^2*al];
fy=[2*eta*V*(al^2+alo^2) 2*eta*V^2*al+T*sa  cg; -2*V*al -V^2-T*ca -sg];
% fyy is the 6 by 3 matrix [df1/dyy; df2/dyy]:
fyy=[2*eta*(al^2+alo^2) 4*eta*V*al 0; 4*eta*V*al 2*eta*V^2+T*ca 0;...
     0 0 -sg; -2*al -2*V 0; -2*V T*sa 0; 0 0 -cg];	     
if flg==1, L=ga; Ly=[0 0 1]; Lyy=zeros(3);
elseif flg==2, L=V*sg; Ly=[sg 0 V*cg]; Lyy=[0 0 cg; 0 0 0; cg 0 -V*sg];
end
function [L,f,Ly,fy,Lyy,fyy]=clmb727(y)            
% Subroutine for Pb. 1.3.21 using POP & Pb. 1.5.21 using POPN; max
% climb angle (flg=1) or climb rate (flg=2) for 727 at sea level;
% y=[V ga al]'; charac. length lc=2W/(g*rho*S); V^2 in g*lc,
% (thrust,drag,lift) in W=weight, r in lc;    1/94, 10/96, 1/12/98  
%
global flg; v=y(1); ga=y(2); al=y(3);c=pi/180; ep=2*c; al1=12*c;
ca=cos(al+ep); sa=sin(al+ep); cg=cos(ga); sg=sin(ga);
ao=.2476; a1=-.04312; a2=.008392; bo=.07351; b1=-.08617; b2=1.996;
co=.1667; c1=6.231; if al<al1, c2=0; else c2=-21.65; end
th=ao+a1*v+a2*v^2; cd=bo+b1*al+b2*al^2; cl=co+c1*al+c2*(al-al1)^2;
if flg==1, L=ga; Ly=[0 1 0]; Lyy=zeros(3);
elseif flg==2, L=v*sg; Ly=[sg v*cg 0]; 
   Lyy=[0 cg 0; cg -v*sg 0; 0 0 0];
end
thv=a1+2*a2*v; cda=b1+2*b2*al; cla=c1+2*c2*(al-al1);
thvv=2*a2; cdaa=2*b2; claa=2*c2;
f=[th*ca-cd*v^2-sg; th*sa+cl*v^2-cg];
fy=[thv*ca-2*cd*v -cg -th*sa-cda*v^2; ...
    thv*sa+2*cl*v  sg  th*ca+cla*v^2];
fyy=[thvv*ca-2*cd 0 -thv*sa-2*cda*v; 0 -sg 0;
   -thv*sa-2*v*cda 0 -th*ca+claa*v^2;
   thvv*sa-2*cl 0 thv*ca+2*cla*v; 0 cg 0;
   thv*ca+2*cla*v 0 -thv*ca+claa*v^2];

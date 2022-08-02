function [L,f,Ly,fy]=minturn(y,ga,flg)           
% Subroutine for Pb. 1.3.9; min radius turn (max 1/r, flg=1)
% or max turn rate (flg=2) of a glider; charac. length lc=
% 2m(eta)/(rho*S*Cla); r in units of lc, V in sqrt(g*lc);
% y=[V al sg];                                 1/95, 7/17/02
%
global ga flg; alm=1/12; eta=.5; V=y(1); al=y(2); sg=y(3);
cs=cos(sg); ss=sin(sg); cg=cos(ga); sg=sin(ga);
f=[sg-eta*V^2*(al^2+alm^2); cg-V^2*al*cs];
fy=[-2*V*eta*(al^2+alm^2) -2*al*eta*V^2 0; ...
    -2*V*al*cs -V^2*cs  V^2*al*sg];
if flg==1,
  L=al*ss/cg^2; Ly=[0 ss al*cs]/cg^2;
elseif flg==2,
  L=tan(sg)/V; Ly=[-tan(sg)/V^2  0  1/(V*cg^2)];
end


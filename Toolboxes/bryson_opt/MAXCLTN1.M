function [f,g]=maxcltn1(p,ga,flg)
% Subroutine for Pb.1.3.13; min climbing turn radius (flg=1) or max
% climbing turn rate (flg=2); p=[V alpha sigma];     10/96, 9/10/98
%
V=p(1); al=p(2); sg=p(3); T=.2; alm=1/12; eta=.5; ep=2*pi/180; 
g(1)=sin(ga)-T*cos(al+ep)+eta*V^2*(al^2+alm^2); 
g(2)=cos(ga)-cos(sg)*(T*sin(al+ep)+V^2*al);
if flg==1,  f=-tan(sg)/(V^2*cos(ga));                       % -1/r
elseif flg==2,  f=-tan(sg)/V;                            % -psidot
end
function [c,ceq]=maxcltn1_f(p,ga,flg)
% Subroutine for Pb.1.3.13;                    10/96, 6/27/02
%
V=p(1); al=p(2); sg=p(3); T=.2; alm=1/12; eta=.5; ep=2*pi/180; 
ceq(1)=sin(ga)-T*cos(al+ep)+eta*V^2*(al^2+alm^2); 
ceq(2)=cos(ga)-cos(sg)*(T*sin(al+ep)+V^2*al);
c=[];
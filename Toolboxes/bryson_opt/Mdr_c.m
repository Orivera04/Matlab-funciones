function [c,ceq]=mdr_c(p,flg)             
% Subroutine for Pb. 1.3.08;       10/96, 6/27/02
%
V=p(1); ga=p(2); al=p(3); alm=1/12; eta=1/2;
ceq=[al*tan(ga)-eta*(al^2+alm^2); al*V^2-cos(ga)];
c=[];
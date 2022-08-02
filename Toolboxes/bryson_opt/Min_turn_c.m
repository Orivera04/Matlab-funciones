function [c,ceq]=min_turn_c(p,ga,flg)           
% Subroutine for p1_3_09c;                1/95, 3/22/02
%
V=p(1); al=p(2);  sg=p(3);  alm=1/12; eta=1/2; c=[]; 
ceq=[sin(ga)-eta*V^2*(al^2+alm^2); cos(ga)-V^2*al*cos(sg)];

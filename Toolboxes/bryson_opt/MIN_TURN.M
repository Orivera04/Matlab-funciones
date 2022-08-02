function [f,g]=min_turn(p,ga,flg)           
% Subroutine for p1_3_09c; max turn rate or min radius turn of a glider;
% charac. length lc = 2m(eta)/(rho*S*Cla); V in units of sqrt(g*lc), r
% in lc; p=[V al sg]; 		                         1/95, 10/96, 9/10/98
%
V=p(1); al=p(2);  sg=p(3);  alm=1/12; eta=1/2; 
g=[sin(ga)-eta*V^2*(al^2+alm^2); cos(ga)-V^2*al*cos(sg)];
if flg==1, f=-al*sin(sg)/(cos(ga))^2;  	             % - 1/turn radius 
elseif flg==2, f=-tan(sg)/V;                               % - turn rate
end
function [f,g]=clmb_727(y,flg)            
% Subroutine for Pb. 1.3.21c using CONSTR; max climb angle or climb
% rate for 727 at sea level; y = [V ga al]'; ch. length lc=2W/(g*rho*S);
% V^2 in g*lc, (thrust,drag,lift) in W = weight, r in lc; 1/94, 10/13/96  
%
V=y(1); ga=y(2); al=y(3); ep=2*pi/180; al1=12*pi/180;
ao=.2476;  a1=-.03049;  a2=.004196;
bo=.07351; b1=-.08617;  b2=1.996; co=.1667;  c1=6.231;    
if al<al1, c2=0; else c2=-21.65; end
th=ao+a1*V+a2*V^2; cd=bo+b1*al+b2*al^2; cl=co+c1*al+c2*(al-al1)^2;
%
g(1)=th*cos(al+ep)-cd*V^2-sin(ga);
g(2)=th*sin(al+ep)+cl*V^2-cos(ga);     
%
if flg==1, f=-ga;                               % Maximize climb angle
elseif flg==2, f=-V*sin(ga); end                 % Maximize climb rate


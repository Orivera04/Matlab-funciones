function [c,ceq]=clmb_727_c(p,flg)            
% Subroutine for Pb. 1.3.21c;            1/94, 6/27/02  
%
V=p(1); ga=p(2); al=p(3); ep=2*pi/180; al1=12*pi/180;
ao=.2476;  a1=-.03049;  a2=.004196;
bo=.07351; b1=-.08617;  b2=1.996; co=.1667;  c1=6.231;    
if al<al1, c2=0; else c2=-21.65; end
th=ao+a1*V+a2*V^2; cd=bo+b1*al+b2*al^2; 
cl=co+c1*al+c2*(al-al1)^2;
ceq(1)=th*cos(al+ep)-cd*V^2-sin(ga);
ceq(2)=th*sin(al+ep)+cl*V^2-cos(ga); 
c=[];
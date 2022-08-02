function [c,ceq]=cltn_c(y,ga,flg)              
% Subroutine for Pb. 1.3.22b;                      11/96, 3/22/02 
%
V=y(1); al=y(2); sg=y(3); ep=2*pi/180; al1=12*pi/180;
ca=cos(al+ep); sa=sin(al+ep); cs=cos(sg); ss=sin(sg); ts=tan(sg); 
cg=cos(ga); sg=sin(ga);
ao=.2476;  a1=-.04312; a2=.008392;
bo=.07351; b1=-.08617; b2=1.996; co=.1667;  c1=6.231; 
if al<=al1, c2=0; else c2=-21.65; end
th=ao+a1*V+a2*V^2; cd=bo+b1*al+b2*al^2; cl=co+c1*al+c2*(al-al1)^2;
ceq(1)=th*ca-cd*V^2-sg; ceq(2)=(th*sa+cl*V^2)*cs-cg;     
c=[];


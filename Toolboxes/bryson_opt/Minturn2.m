function [L,f,Ly,fy,Lyy,fyy]=minturn2(y)           
% Subroutine for Pb. 1.5.9; min radius turn or max turn rate of 
% a glider; lc=2m(eta)/(rho*S*Cla); r in units of lc, V in 
% sqrt(g*lc); y=[V al sg];                           1/95, 8/15/02
%
global ga flg; de=1/12; V=y(1); al=y(2); sg=y(3); cs=cos(sg);
ss=sin(sg); ca=cos(ga); sa=sin(ga);
f=[sa-V^2*(al^2+de^2/4); ca-V^2*al*cs];
fy=[-2*V*(al^2+de^2/4) -2*al*V^2 0; -2*V*al*cs -V^2*cs V^2*al*ss];
%
% fyy is a 6 by 3 matrix = [df1/dydy;  df2/dydy]:
fyy=[-2*(al^2+de^2/4) -4*al*V 0; -4*al*V  -2*V^2 0; 0 0 0; ...
     -2*al*cs -2*V*cs  2*V*al*ss; -2*V*cs 0 V^2*ss; ...
     2*V*al*ss V^2*ss V^2*al*cs];
%
if flg==1,
    L=al*ss/ca^2; Ly=[0 ss al*cs]/ca^2;
	Lyy=[0 0 0; 0 0 cs; 0 cs -al*ss]/(ca)^2;
elseif flg==2,
	L=tan(sg)/V; Ly=[-tan(sg)/V^2 0 1/(V*(cs)^2)];
	Lyy=[2*tan(sg)/V^3 0 -1/(V*cs)^2; 0 0 0; -1/(V*cs)^2 ...
       0 2*ss/(V*cs^3)];
end
 
  

function f=ctdp(p,be,tau)
% Approx. solution with three const. thrust direc. periods;
% z=Vo^2/(2a*ro); ga=gamma, be=beta; tau=aT/Vo;		       1/97, 7/4/98
%
z=p(1); ga=p(2); th=be-ga; d=(1+sec(th)/tau)^2-2; ga1=atan2(tan(th),d);
if ga1<0, ga1=pi+ga1; end; z1=2*sin(ga)/(tau^2*sin(th));
f=[z-z1 ga-ga1];
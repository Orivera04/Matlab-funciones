function sp=minfuelb(t,s)     
% Subroutine for Pb. 3.3.19, min fuel holding path, V=const.
% s=[th thdot x y]'; u=tan(sg)=thdot; sg=bank angle; (x,y)
% in V^2/g, time in V/g;                             1/15/98
%	
th=s(1); tf=60; om=2*pi/tf; xf=10; D=2*sqrt(1-xf/tf);
sp=[s(2) -om^2*sin(th) cos(th) sin(th)]';

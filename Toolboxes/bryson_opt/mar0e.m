function yp=mar0e(t,y)	
% Subroutine for Pb. 2.6.9f,b; EL eqns. for shooting solution of
% TDP for max orbital radius;                             8/12/02
%
T=.1405; b=.07489; a=T/(1-b*t);
r=y(1); u=y(2); v=y(3); lr=y(4); lu=y(5); lv=y(6); 
be=atan2(lu,lv); si=sin(be); co=cos(be);
yp=[u v^2/r-1/r^2+a*si -u*v/r+a*co ...
   -lr*(-v^2/r+2/r^3)-lv*u*v/r^2 -lr+lv*v/r -lu*2*v/r-lv*u/r]';
	
	
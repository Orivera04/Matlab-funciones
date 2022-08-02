function yp=marslin0e(t,y)	
% Subroutine for Pb. 2.6.17f,b; EL eqns. for shooting 
% of TDP for max orbital radius w. small dr;  8/21/02
%
T=.1405; b=.07489; a=T/(1-b*t);
r=y(1); u=y(2); v=y(3); lr=y(4); lu=y(5); lv=y(6); 
be=atan2(lu,lv); si=sin(be); co=cos(be);
yp=[u r+2*v+a*si -u+a*co -lu -lr+lv -2*lu]';

	
function yp=martsse(t,y)      
% Subroutine for Pb. 4.6.21f,b; solar sail DP for min time to the Mars
% orbit; s=[r u v th]';                                   4/97, 2/5/98
%
al=.17;		                         % Kelley's value; Hur used al=.02
r=y(1); u=y(2); v=y(3); lr=y(5); lu=y(6); lv=y(7); lt=y(8);
b=lu/lv; th=.5*acos((1+b*sqrt(8+9*b^2))/(3*(1+b^2))); 
c=cos(th); si=sin(th); a=(al/r^2)*c^2;
f=[u; v^2/r-1/r^2+a*c; -u*v/r+a*si; v/r];   
fs=[0 1 0 0; -(v/r)^2+2/r^3-2*a*si/r 0  2*v/r 0; u*v/r^2-2*a*c/r ...
    -v/r -u/r 0; -v/r^2 0 1/r 0];
la=[lr lu lv lt]';
yp=[f; -fs'*la];


	

function yp=mare(t,y)                         
% Euler-Lagrange Eqns. for min tf to Mars; y=[r u v lr lu lv]';
%                                                 2/97, 1/21/98
%
T=.1405; mdot=.07489; r=y(1); u=y(2); v=y(3); lr=y(4); lu=y(5);
lv=y(6); a=T/(1-mdot*t); la=[lr lu lv]'; d=sqrt(lu^2+lv^2);                                   
f=[u; v^2/r-1/r^2+a*lu/d; -u*v/r+a*lv/d];
fs=[0 1 0; -(v/r)^2+2/r^3 0 2*v/r; u*v/r^2 -v/r -u/r];
yp=[f; -fs'*la];


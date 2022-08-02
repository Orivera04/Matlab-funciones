function yp=marte(t,y)
% Subroutine for e04_6_2,3, e04_7_1,2,3 & p4_6_17,18; EL eqns. for
% min tf low-thrust path from Earth to another planet; y=[r u v lr
% lu lv]';                                            2/97, 9/5/02
%
T=.1405; mdot=.07489; r=y(1); u=y(2); v=y(3); lr=y(4); lu=y(5);
lv=y(6); a=T/(1-mdot*t); la=[lr lu lv]'; d=sqrt(lu^2+lv^2);                                   
f=[u; v^2/r-1/r^2-a*lu/d; -u*v/r-a*lv/d];
fs=[0 1 0; -(v/r)^2+2/r^3 0 2*v/r; u*v/r^2 -v/r -u/r];
yp=[f; -fs'*la];


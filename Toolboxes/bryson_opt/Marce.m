function yp=marce(t,y)
% EL eqns. for min tf to Mars;
% y=[r u v th lr lu lv lth]';            2/97, 7/14/02
%
T=.1405; mdot=.07489; r=y(1); u=y(2); v=y(3); lr=y(5);
lu=y(6); lv=y(7); lth=y(8); a=T/(1-mdot*t); 
la=[lr lu lv lth]'; den=sqrt(lu^2+lv^2);                                   
f=[u; v^2/r-1/r^2+a*lu/den; -u*v/r+a*lv/den; v/r];
fs=[0 1 0 0; -(v/r)^2+2/r^3 0 2*v/r 0; u*v/r^2 -v/r ...
    -u/r 0; -v/r^2 0 1/r 0];
yp=[f; -fs'*la];



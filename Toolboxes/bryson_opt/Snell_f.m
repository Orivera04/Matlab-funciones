function f=snell_f(p)                          
% Subroutine for Pb. 1.3.05;         1/94, 6/27/02 
%
th1=p(1); th2=p(2); y=[100 300]; x2=300; v=[25 6];
f=y(1)/(v(1)*cos(th1))+(y(2)-y(1))/(v(2)*cos(th2));



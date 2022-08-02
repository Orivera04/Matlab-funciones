function [L,f,Ly,fy]=rctelps(y)
% Subroutine for solving Pb. 1.3.3 with POP; rectangular box of max
% volume inscribed in an ellipsoid; 		           10/96, 9/10/98
%
L=8*y(1)*y(2)*y(3); Ly=8*[y(2)*y(3) y(1)*y(3) y(1)*y(2)];
f=y(1)^2+y(2)^2/4+y(3)^2/9-1; fy=[2*y(1) y(2)/2 2*y(3)/9];


 
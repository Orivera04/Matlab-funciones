function [L,f,Ly,fy,Lyy,fyy]=rctelps2(y)
% Subroutine for Pb. 1.5.2 with POPN; rectangular box of max volume 
% inscribed in an ellipsoid; 		                       10/96, 6/24/98
%
y1=y(1); y2=y(2); y3=y(3); 
L=8*y1*y2*y3;  Ly=8*[y2*y3 y1*y3 y1*y2]; 
Lyy=8*[0 y3 y2; y3 0 y1; y2 y1 0];
f=y1^2+y2^2/4+y3^2/9-1;  fy=[2*y1 y2/2 2*y3/9];
fyy=[ 2 0 0; 0 1/2 0; 0 0 2/9];


 
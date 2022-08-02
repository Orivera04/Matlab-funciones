function [f,g]=snell(k)                          
% Subroutine for Pb. 1.3.5 - Min time path thru region with two layers
% of constant velocity magnitude;                 1/94, 10/96, 9/10/98 
%
th1=k(1); th2=k(2); y=[100 300]; x2=300; v=[25 6];
f=y(1)/(v(1)*cos(th1))+(y(2)-y(1))/(v(2)*cos(th2));
g=x2-y(1)*tan(th1)-(y(2)-y(1))*tan(th2);


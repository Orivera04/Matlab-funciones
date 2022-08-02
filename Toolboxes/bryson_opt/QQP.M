function [L,f,Ly,fy,Lyy,fyy]=qqp(y)     
% Subroutine for Pbs. 1.3.19 & 1.5.19, a Quadratic-
% Quadratic Pb. using POP or POPN;    10/96, 4/1/02
%
L=y(1)*y(2)+2*y(1)*y(3)+3*y(2)*y(3);
Ly=[y(2)+2*y(3)  y(1)+3*y(3) 2*y(1)+3*y(2)];
Lyy=[0 1 2; 1 0 3; 2 3 0];
f=y(1)^2+2*y(2)^2+3*y(3)^2-1;
fy=[2*y(1) 4*y(2) 6*y(3)];
fyy=diag([2 4 6]);
 
 


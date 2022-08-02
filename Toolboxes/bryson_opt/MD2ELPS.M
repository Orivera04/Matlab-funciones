function [L,f,Ly,fy,Lyy,fyy]=md2elps(p) 
% Subroutine for Pbs. 1.3.20 & 1.5.20, min distance between two ellipses 
% using POP or POPN;                                1/95, 10/96, 6/24/98 
%
x1=p(1); y1=p(2); x2=p(3); y2=p(4); th=pi/6; c=cos(th); s=sin(th);
xb=c*x1+s*y1; yb=s*x1-c*y1;
L=(x1-x2)^2+(y1-y2)^2;
f=[x2^2/16+y2^2/4-1; xb^2/4+yb^2-1];
Ly=[2*(x1-x2) 2*(y1-y2) -2*(x1-x2) -2*(y1-y2)];
fy=[0 0 x2/8 y2/2;(xb/2)*c+2*yb*s (xb/2)*s-2*yb*c 0 0];
Lyy=[ 2 0 -2 0; 0 2 0 -2; -2 0 2 0; 0 -2 0 2];
fyy=[0 0 0 0; 0 0 0 0; 0 0 1/8 0; 0 0 0 1/2; ...
     c^2/2+2*s^2 c*s/2-2*s*c 0 0; ...
     c*s/2-2*s*c s^2/2+2*c^2 0 0; 0 0 0 0; 0 0 0 0];
 
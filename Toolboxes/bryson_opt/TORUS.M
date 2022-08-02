function sp=torus(t,s)                                    
% Subroutine for Pb. 8.7.4; EL eqns for min dist paths on a torus;
% s=[th be]';                               3/94, 12/96, 1/98, 7/4/98
%
a=1.5; th=s(1); be=s(2); sp=[(a+cos(th))*tan(be);-sin(th)];


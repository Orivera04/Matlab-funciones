function f=vdpt_f(p)       
% Subroutine for p4_3_1; VDP for min time to a point with gravity; 
% v in sqrt(g*xf), t in sqrt(xf/g), (x,y) in xf;    12/96, 6/25/98
%
global yf; f=1-cos(p)-yf*(p-sin(p));
	

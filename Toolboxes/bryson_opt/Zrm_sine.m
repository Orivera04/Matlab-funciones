function sp=zrm_sine(t,y1)                                     
% Subroutine for Pb. 8.7.3; EL eqns for Zermelo Pb. with sinusoidal
% current;  s=[x y lax lay]';			            	3/7/93, 12/96, 7/4/98
%
uo=1; y=y1(2); lay=y1(4); th=atan(lay);
sp=[cos(th)+uo*(sin(y))^2; sin(th); 0; -uo*sin(2*y)];


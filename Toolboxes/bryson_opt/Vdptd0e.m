function yp=vdptd0e(t,y)	
% Subroutine for Pb. 2.6.6f,b; EL eqns. for shooting solution of VDP
% for max range with gravity, thrust, & drag;     5/97, 8/97, 2/3/98
%
global a; V=y(1); x=y(2); lv=y(4); lx=y(5); 
if V==0, ga=pi/2; else ga=atan(lv/V); end;
c=cos(ga); si=sin(ga); yp=[a+si-V^2 V*c V*si -lx*c+2*lv*V  0  0]';
	
	
function yp=vdpt0e(t,y)	
% Subroutine for Pb. 2.6.5f,b EL eqns. for VDP for max range with
% gravity and thrust;%				                         3/28/97
%
a=1; V=y(1); x=y(2); lv=y(4); lx=y(5); 
if V==0, ga=pi/2; else ga=atan(lv/V); end;
yp=[a+sin(ga) V*cos(ga) V*sin(ga) -lx*cos(ga) 0 0]';
	
	
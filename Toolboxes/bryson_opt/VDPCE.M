function yp=vdpce(t,y)	
% Subroutine for Pb. 3.6.1; EL eqns for VDP for max range w. gravity
% & yf specified; 	                                   4/97, 2/4/98
%		
V=y(1); y1=y(2); x=y(3); lv=y(4); ly=y(5); lx=y(6);
if abs(V)<.001, ga=pi/2; else ga=atan(ly+lv/V); end;
c=cos(ga); si=sin(ga);
yp=[si V*si V*c -lx*c-ly*si 0 0]';
	

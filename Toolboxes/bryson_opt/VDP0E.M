function yp=vdp0e(t,y)	
% Subroutine for Pb. 2.6.1f,b; fwd. EL eqns. for FOPOF; VDP for max 
% range with gravity (dual of Brachistochrone Pb.);          3/28/97
%
V=y(1); x=y(2); lv=y(4); lx=y(5); 
if V==0, ga=pi/2; else ga=atan(lv/V); end;
yp=[sin(ga) V*cos(ga) V*sin(ga) -lx*cos(ga) 0 0]';
	
	
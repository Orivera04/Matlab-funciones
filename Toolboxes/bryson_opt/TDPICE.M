function sp=tdpice(t,s)
% Subroutine for p3_6_05f,b; TDP for max xf with yf=0; s=[u v x y]';
% th=control; 		                                     4/97, 6/23/98
%
u=s(1); v=s(2); x=s(3); y=s(4); lu=s(5); lv=s(6); lx=s(7); ly=s(8); 
th=atan2(-lv,lu); c=cos(th); si=sin(th); sp=[c si u v -lx -ly 0 0]';
	
	
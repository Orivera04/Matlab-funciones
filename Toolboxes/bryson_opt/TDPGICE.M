function sp=tdpgice(t,s)
% Subroutine for p3_6_08f,b; TDP for max xf with gravity and spec. yf;
% s=[u v x y]'; th=control; 		                        4/97, 6/23/98
%
global g; u=s(1); v=s(2); x=s(3); y=s(4); lu=s(5); lv=s(6); lx=s(7);
ly=s(8); th=atan2(-lv,lu); c=cos(th); si=sin(th);
sp=[c si-g u v -lx -ly 0 0]';
	
	
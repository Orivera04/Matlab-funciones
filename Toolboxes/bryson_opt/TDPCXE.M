function sp=tdpcxe(t,s)
% Subroutine for p3_6_07f,b; TDP for max uf  and (vf,yf,xf) specified;
% s=[u v y x]'; th=control; 		                     2/97, 6/23/98
%
u=s(1); v=s(2); lu=s(5); lv=s(6); ly=s(7); lx=s(8); 
th=atan2(lv,lu); c=cos(th); si=sin(th); sp=[c si v u -lx -ly 0 0]';
	
	
function sp=tdpcgxe(t,s)
% Subroutine for Pb. 3.6.10f,b; TDP for max uf with gravity, (vf,yf,xf)
% specified; s=[u v y x]';  be = control;                       4/1/97
%
g=1/3; u=s(1); v=s(2); lu=s(5); lv=s(6); ly=s(7); lx=s(8); 
be=atan2(lv,lu); c=cos(be); si=sin(be);
sp=[c si-g v u -lx -ly 0 0]';
	
	
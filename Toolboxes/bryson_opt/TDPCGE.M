function sp=tdpcge(t,s)
% Subroutine for p3_6_09f,b; TDP for max uf and (vf,yf) specified;
% s=[u v y x]'; th=control;                           4/97, 2/4/98
%
global g; u=s(1); v=s(2); lv=s(6); ly=s(7); th=atan(lv); 
sp=[cos(th) sin(th)-g v u 0 -ly 0 0]';
	
	
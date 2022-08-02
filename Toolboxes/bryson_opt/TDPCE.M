function sp=tdpce(t,s)
% Subroutine for p3_6_06f; TDP for max uf  and (vf,yf) specified;
% s=[u v y x]'; th = control; 		                        4/97, 6/23/98
%
u=s(1); v=s(2); lv=s(6); ly=s(7); th=atan(lv); c=cos(th); si=sin(th);
sp=[c si v u 0 -ly 0 0]';
	
	
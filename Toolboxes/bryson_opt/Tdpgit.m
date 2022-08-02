function [f1,f2,f3]=tdpgit(th,s,t,flg)
% Subroutine for p4_4_08; TDP for min tf with gravity and spec. xf, yf,
% V0, ga0; s=[u v x y]'; th = control; (u,v) in V0, (x,y) in V0^2/2a,
% t in V0/a, g in a; 		                              2/97, 6/25/98
%
global xf yf g; u=s(1); v=s(2); x=s(3); y=s(4); c=cos(th); si=sin(th);
if flg==1, f1=[c -si-g 2*u 2*v]';
elseif flg==2, f1=[t x-xf y-yf]'; f2=[0 0 0 0; 0 0 1 0; 0 0 0 1];
	 f3=[1 0 0]';
elseif flg==3, f1=[zeros(2,4); 2 0 0 0; 0 2 0 0]; f2=[-si -c 0 0]';
end
	
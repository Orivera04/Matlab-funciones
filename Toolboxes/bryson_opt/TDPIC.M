function [f1,f2,f3]=tdpic(th,s,t,flg)
% Subroutine for Pb. 3.4.05; TDP for max xf with yf=0; (u,v) in a*tf, 
% (x,y) in a*tf^2, t in tf; s=[u v x y]'; th=control;  2/97, 6/17/98
%
u=s(1); v=s(2); x=s(3); y=s(4); 	c=cos(th); si=sin(th);
if flg==1, f1=[c si u v]';
elseif flg==2, f1=[x y]'; f2=[zeros(2) eye(2)];
elseif flg==3, f1=[zeros(2,4); 1 0 0 0; 0 1 0 0]; f2=[-si c 0 0]';
end
	
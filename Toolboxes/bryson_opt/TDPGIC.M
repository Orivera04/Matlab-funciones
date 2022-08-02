function [f1,f2]=tdpgic(th,s,t,flg)
% Subroutine for p3_4_08 & p3_6_08; TDP for max xf with gravity and spec.
% yf; (u,v) in a*tf, (x,y) in a*tf^2, t in tf, g in a; s=[u v x y]'; 
% th=control;                                       2/97, 1/98, 6/23/98
%
global yf g; u=s(1); v=s(2); x=s(3); y=s(4); c=cos(th); si=sin(th);
if flg==1, f1=[c si-g u v]';
elseif flg==2, f1=[x y-yf]'; f2=[zeros(2) eye(2)];
elseif flg==3, f1=[zeros(2,4); 1 0 0 0; 0 1 0 0]; f2=[-si c 0 0]';
end
	
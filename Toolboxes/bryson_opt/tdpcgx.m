function [f1,f2]=tdpcgx(th,s,t,flg)
% Subroutine for p3_4_10 & 3_6_10; TDP for max uf w. gravity to vf=0
% & (yf,xf) specified; s=[u v y x]'; th=control; t in tf, (u,v) in a*tf,
% (y,x) in a*tf^2, g in a;                          2/97, 2/98, 6/23/98
%
global vf yf xf g; u=s(1); v=s(2); y=s(3); x=s(4); c=cos(th); s=sin(th);
if flg==1, f1=[c s-g v u]';
elseif flg==2, f1=[u v-vf y-yf x-xf]';  f2=eye(4);
elseif flg==3, f1=[zeros(2,4); 0 1 0 0; 1 0 0 0];  f2=[-s c 0 0]';
end
	
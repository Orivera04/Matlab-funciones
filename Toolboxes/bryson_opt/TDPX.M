function [f1,f2]=tdpx(th,s,t,flg)
% Subroutine for Pb. 3.4.7; TDP for max uf with specified
% (vf,yf,xf); s=[u v y x]'; th = control; t in tf, (u,v)
% in a*tf, (y,x) in a*tf^2; 			       2/97, 1/20/98
%
yf=.2; xf=.15; u=s(1); v=s(2); y=s(3); x=s(4);
c=cos(th);  s=sin(th);
if flg==1,
 f1=[c s v u]';
elseif flg==2,
 f1=[u v y-yf x-xf]'; f2=eye(4);
elseif flg==3,
 f1=[zeros(2,4); 0 1 0 0; 1 0 0 0]; f2=[-s c 0 0]';
end
	
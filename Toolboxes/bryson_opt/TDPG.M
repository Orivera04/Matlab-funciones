function [f1,f2]=tdpcg(th,s,t,flg)
% Subroutine for Pb. 3.4.9; TDP for max uf with gravity,
% thrust, and drag & (vf,yf) specified; s=[u v y x]';
% th = control;				               2/97, 2/4/98
%
yf=.2; g=1/3; u=s(1); v=s(2); y=s(3); c=cos(th);
s=sin(th);
if flg==1,
 f1=[c s-g v u]';
elseif flg==2,
 f1=[u v y-yf]'; f2=[eye(3) zeros(3,1)];
elseif flg==3,
 f1=[zeros(2,4); 0 1 0 0; 1 0 0 0];  f2=[-s c 0 0]';
end
	
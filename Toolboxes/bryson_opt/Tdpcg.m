function [f1,f2]=tdpcg(th,s,t,flg)
% Subroutine for p3_4_09 & p3_6_09; TDP for max uf w. gravity to vf=0 
% with specified yf; s=[u v y x]'; th=control;     2/97, 2/98, 6/23/98
%
global vf yf g; u=s(1); v=s(2); y=s(3); co=cos(th); si=sin(th);
if flg==1, f1=[co si-g v u]';
elseif flg==2, f1=[u v-vf y-yf]'; f2=[eye(3) zeros(3,1)];
elseif flg==3, f1=[zeros(2,4); 0 1 0 0; 1 0 0 0];  f2=[-si co 0 0]';
end
	
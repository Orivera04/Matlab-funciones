function [f1,f2]=tdpcx(th,s,t,flg)
% Subroutine for p3_4_07 & p3_6_07; TDP for max uf with specified
% (vf,yf,xf); s=[u v y x]'; th=control; t in tf, (u,v) in a*tf, (y,x)
% in a*tf^2;                                        2/97, 2/98, 6/23/98
%
global vf yf xf; u=s(1); v=s(2); y=s(3); x=s(4); c=cos(th); si=sin(th);
if flg==1, f1=[c si v u]';
elseif flg==2, f1=[u v-vf y-yf x-xf]'; f2=eye(4);
elseif flg==3, f1=[zeros(2,4); 0 1 0 0; 1 0 0 0]; f2=[-si c 0 0]';
end
	
function [f1,f2,f3]=tdpgt(th,s,t,flg)
% Subroutine for p4_4_09; TDP for min tf to vf=0 & spec. (uf,yf) with
% gravity; s=[u v y x]'; th=control; (u,v) in uf, (x,y) in uf^2/a, t
% in uf/a;	                                      2/97, 6/98, 9/14/98
%
global yf g; u=s(1); v=s(2); y=s(3); c=cos(th); si=sin(th);
if flg==1, f1=[c si-g v u]';
elseif flg==2, f1=[t u-1 v y-yf]'; f2=[1 0 0 0; eye(3) zeros(3,1)];
	 f3=[1 0 0 0]';
elseif flg==3, f1=[zeros(2,4); 0 1 0 0; 1 0 0 0]; f2=[-si c 0 0]';
end
	
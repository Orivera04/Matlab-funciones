function [f1,f2,f3]=tdpit(th,s,t,flg)
% Subroutine for p4_4_05; TDP for min tf to yf=0, specified xf; 
% s=[u v x y]'; th=control; (u,v) in V0, (x,y) in V0^2/2a, t in V0/a;
%                                                2/97, 6/98, 9/13/98
%
global xf; u=s(1); v=s(2); x=s(3); y=s(4); c=cos(th); s=sin(th);
if flg==1, f1=[c -s 2*u 2*v]';
elseif flg==2, f1=[t x-xf y]'; f2=[0 0 0 0; 0 0 1 0; 0 0 0 1];
 f3=[1 0 0]';
elseif flg==3, f1=[zeros(2,4); 2 0 0 0; 0 2 0 0]; f2=[-s -c 0 0]';
end
	
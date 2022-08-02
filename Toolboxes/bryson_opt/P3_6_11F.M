% Script p3_6_11f.m; VDP for max range with gravity, thrust, and spec.
% yf using FOPCF; s=[V y x]';                           2/97, 5/28/02
%
clear; clear global; global yf a; yf=.1; a=.5; la0=[.693 1.872 1];
nu=1.872; p0=[la0 nu]; s0=[0 0 0]'; tf=1; name='vdpct';
optn=optimset('Display','Iter','MaxIter',500); 
p=fsolve('fopcf',p0,optn,name,s0,tf);
[f,t,y]=fopcf(p,name,s0,tf); y1=y(:,2); x=y(:,3); N=length(t);
%
figure(1); clf;plot(x,y1,x(N),y1(N),'ro',0,0,'ro'); grid 
axis([0 .4 -.15 .15]); ylabel('y/gt_f^2'); xlabel('x/gt_f^2')

	
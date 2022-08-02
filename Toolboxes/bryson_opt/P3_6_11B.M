% Script p3_6_11b.m; VDP for max range with gravity, thrust, and
% spec. yf using FOPCB; s=[V y x]';                 8/97, 5/28/02
%
clear; clear global; global yf a; yf=.1; a=.5; sf=[.49 .1 .3328]; 
nu=1.8723; p0=[sf nu];s0=[0 0 0]'; tf=1; name='vdpct'; 
optn=optimset('Display','Iter','MaxIter',500); 
p=fsolve('fopcb',p0,optn,name,s0,tf);
[f,t,y]=fopcb(p,name,s0,tf); N=length(t); y1=y(:,2); x=y(:,3);   
%
figure(1); clf; plot(x,y1,x(1),y1(1),'ro',0,0,'ro'); grid
axis([0 .4 -.15 .15]); ylabel('y/gt_f^2'); xlabel('x/gt_f^2')

	
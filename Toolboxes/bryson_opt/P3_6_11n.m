% Script p3_6_11n.m; VDP for max range with gravity, thrust, & spec. 
% yf using FOPCN; s=[V y x]';                          2/97, 5/28/02
%
clear; clear global; global a yf; a=.5; yf=.1; name='vdpct'; N=20;
ga0=(pi/2)*[-1:2/N:1]; tf=1; t=[0:1/N:1]; s0=[0 0 0]'; nu=1.8720;
p0=[ga0 nu]; optn=optimset('Display','Iter','MaxIter',500); 
p=fsolve('fopcn',p0,optn,name,s0,tf); [f,s,ga]=fopcn(p,name,s0,tf);
N1=length(ga); N=N1-1; V=s(1,:); y=s(2,:); x=s(3,:); 
%
figure(1); clf; plot(x,y,x(N1),y(N1),'ro',0,0,'ro'); grid
ylabel('y/gt_f^2'); xlabel('x/gt_f^2'); axis([0 .35 -.2 .15])
axis('square')
%
figure(2); clf; subplot(211), plot(t,V); grid; ylabel('V')
subplot(212), plot(t,ga*180/pi); grid; xlabel('Time')
ylabel('\gamma (deg)')
	
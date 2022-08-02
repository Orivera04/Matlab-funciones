% Script p4_5_11.m; VDP for min time to a point with gravity and
% thrust; s=[V y x]';                             11/96, 7/16/02
%
clear; clear global; global xf yf a; xf=.3328; yf=-.1; a=.5;
name='vdptt'; N=20; u0=[1:-1/N:0]'; tf=1; tu=tf*[0:1/N:1]';
s0=[0 0 0]'; k=1; told=1e-4; tols=1e-4; mxit=10;
[t,u,s,tf,nu,la0]=fopt(name,tu,u0,tf,s0,k,told,tols,mxit);
y=s(:,2); x=s(:,3); N1=length(y);
%
figure(1); clf; plot(x,-y,x(N1),-y(N1),'ro',0,0,'ro'); grid
axis([0 .4 -.15 .15]); ylabel('y/gt_f^2'); xlabel('x/gt_f^2')

	
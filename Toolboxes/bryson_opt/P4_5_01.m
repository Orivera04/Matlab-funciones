% Script p4_5_01.m; VDP for min time to a point with gravity;
% (x,y) in xf, V in sqrt(g*xf), t in sqrt(xf/g); s=[V y x]'; 
%                                              12/96, 7/16/02
%
clear; clear global; global yf; yf=1/3; name='vdpt'; N=20;
u0=[1:-1/N:0]'; tf=2; tu=tf*[0:1/N:1]'; k=1; s0=[0 0 0]';
told=1e-4; tols=1e-4; mxit=30; 
[t,u,s,tf]=fopt(name,tu,u0,tf,s0,k,told,tols,mxit);
y=s(:,2); x=s(:,3); N1=length(y);
%
figure(1); clf; plot(x,-y,x(N1),-y(N1),'ro',0,0,'ro'); grid
axis([0 1 -.75 0]); ylabel('y/x_f'); xlabel('x/x_f');

	
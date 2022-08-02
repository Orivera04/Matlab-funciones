% Script p3_5_05b.m; DTDP for max xf with gravity, and spec. yf, u0, 
% v0 using DOP0F; (u,v) in a*tf, (x,y) in a*tf^2, t in tf, g in a;
%                                                      3/97, 5/27/02
%
clear; clear global; global yf g; yf=0; g=0; N=20; u0=.5/sqrt(2);
v0=u0; c=pi/180; tf=1; sf=[1.0630 -.3512 .7090 .0019]; 
s0=[u0 v0 0 0]'; t=[0:N]/N; name='dtdpgic'; 
optn=optimset('Display','Iter','MaxIter',500); nu=-.4030;
p0=[sf nu]; th0=-.38; p=fsolve('dopcb',p0,optn,name,th0,s0,tf,N);
[f,s,th]=dopcb(p,name,th0,s0,tf,N); thh=[th th(N)]/c;
u=s(1,:); v=s(2,:); x=s(3,:); y=s(4,:); N1=N+1;
%
figure(1); clf; plot(x,y,0,0,'ro',x(N1),y(N1),'ro'); grid
axis([0 .9 -.75*.4 .75*.5]); xlabel('x/at_f^2') 
ylabel('y/at_f^2')
%
figure(2); clf; subplot(211), zohplot(t,thh); grid
axis([0 1 -50 0]); ylabel('\theta (deg)'); subplot(212), 
plot(t,u,t,v,'r--'); grid; xlabel('t/t_f')
legend('u/at_f','v/at_f',2)


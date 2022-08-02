% Script p3_6_05b.m; TDP for max xf with yf=0 and spec. u0, v0,yf;
% using FOPCB; (u,v) in a*tf, (x,y) in  a*tf^2/2, t in tf; s=[u v x y]';
%                                                          8/97, 5/28/02
%
clear; clear global; global yf; yf=0; u0=.5/sqrt(2); v0=u0; ; c=pi/180;
sf=[1.0607 -.3536 .7071 0]; nu=-1; p0=[sf nu]; s0=[u0 v0 0 0]';
name='tdpic'; optn=optimset('Display','Iter','MaxIter',150); tf=1;
p=fsolve('fopcb',p0,optn,name,s0,tf);
[f,t,y]=fopcb(p,name,s0,tf); u=y(:,1); v=y(:,2); x=y(:,3); y1=y(:,4);
lu=y(:,5); lv=y(:,6); th=atan2(-lv,lu)/c; N=length(t);
%
figure(1); clf; plot(x,y1,x(1),y1(1),'ro',0,0,'ro'); grid 
axis([0 .9 -.75*.4 .75*.5]); xlabel('x/at_f^2'); ylabel('y/at_f^2')
%
figure(2); clf; subplot(211), plot(t,th); grid; ylabel('\theta (deg)')
axis([0 1 -50 0]); subplot(212), plot(t,u,t,v,'r--'); grid
xlabel('t/t_f'); legend('u/at_f','v/at_f',2)

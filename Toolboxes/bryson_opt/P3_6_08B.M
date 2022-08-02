% Script p3_6_08b.m; TDP for max xf with gravity and spec. u0, v0, yf;
% using FOPCB; (u,v) in a*tf, (x,y) in a*tf^2/2, t in tf, g in a;
% s=[u v x y]';                                         8/97, 3/28/02
%
clear; clear global; global yf g; yf=0; g=1/3; u0=.5/sqrt(2); v0=u0;
c=pi/180; sf=[1.2811 -.3535 1.6346 0]; nu=-.4030; p0=[sf nu]; tf=1; 
name='tdpgic'; s0=[u0 v0 0 0]'; 
optn=optimset('Display','Iter','MaxIter',100);
p=fsolve('fopcb',p0,optn,name,s0,tf);
[f,t,y]=fopcb(p,name,s0,tf); N=length(t); u=y(:,1); v=y(:,2);
x=y(:,3); y1=y(:,4); lu=y(:,5); lv=y(:,6); th=atan2(-lv,lu)/c;  
%
figure(1); clf; plot(x,y1,x(1),y1(1),'ro',0,0,'ro'); grid
axis([0 .9 -.75*.4 .75*.5]); xlabel('x/at_f^2');
ylabel('y/at_f^2')
%
figure(2); clf; subplot(211), plot(t,th); grid; axis([0 1 -25 0]) 
ylabel('\theta (deg)'); subplot(212), plot(t,u,t,v,'r--'); grid
xlabel('t/t_f'); legend('u/at_f','v/at_f',2);

	
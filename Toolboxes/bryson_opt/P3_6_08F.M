% Script p3_6_08f.m; TDP for max xf with gravity and spec. u0, v0, yf;
% using FOPCF; (u,v) in a*tf, (x,y) in a*tf^2/2, t in tf, g in a;
% s=[u v x y]';                                          4/97, 5/28/02
%
clear; clear global; global yf g; yf=0; g=1/3; u0=.5/sqrt(2); v0=u0; 
la0=[2 -.8060 1 -.4030]; nu=-.4030; p0=[la0 nu]; tf=1; name='tdpgic'; 
s0=[u0 v0 0 0]'; optn=optimset('Display','Iter','MaxIter',150); 
p=fsolve('fopcf',p0,optn,name,s0,tf); c=pi/180;
[f,t,y]=fopcf(p,name,s0,tf); u=y(:,1); v=y(:,2); x=y(:,3); y1=y(:,4);
lu=y(:,5); lv=y(:,6); th=atan2(-lv,lu)/c; N=length(t);
%
figure(1); clf; plot(x,y1,x(N),y1(N),'ro',0,0,'ro'); grid
axis([0 .9 -.75*.4 .75*.5]); xlabel('x/at_f^2'); ylabel('y/at_f^2')
%
figure(2); clf; subplot(211), plot(t,th); grid; axis([0 1 -25 0]) 
ylabel('\theta (deg)'); subplot(212), plot(t,u,t,v,'r--'); grid
xlabel('t/t_f'); legend('u/at_f','v/at_f',2);

	
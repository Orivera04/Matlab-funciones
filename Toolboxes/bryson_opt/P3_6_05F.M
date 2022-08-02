% Script p3_6_05f.m; TDP for max xf with yf=0 and spec. u0, v0,yf;
% using FOPCF; (u,v) in a*tf, (x,y) in a*tf^2/2, t in tf; s=[u v x y]';
%                                                         3/97, 3/27/02
%
clear; clear global; global yf; yf=0; u0=.5/sqrt(2); v0=u0; c=pi/180; 
la0=[1 -1 1 -1]; nu=-1; p0=[la0 nu]; s0=[u0 v0 0 0]'; tf=1; name='tdpic';
optn=optimset('Display','Iter','MaxIter',200,'MaxFunEvals',1000);
p=fsolve('fopcf',p0,optn,name,s0,tf);
[f,t,y]=fopcf(p,name,s0,tf); u=y(:,1); v=y(:,2); x=y(:,3); y1=y(:,4);
lu=y(:,5); lv=y(:,6); th=atan2(-lv,lu)/c; N=length(t);
%
figure(1); clf; plot(x,y1,x(N),y1(N),'ro',0,0,'ro'); grid 
axis([0 .9 -.75*.4 .75*.5]); xlabel('x/at_f^2'); ylabel('y/at_f^2')
%
figure(2); clf; subplot(211), plot(t,th); grid; ylabel('\theta (deg)')
axis([0 1 -50 0]); subplot(212), plot(t,u,t,v,'r--'); grid
xlabel('t/t_f'); legend('u/at_f','v/at_f',2)

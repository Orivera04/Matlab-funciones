% Script p3_6_09b.m; TDP for max uf with gravity & specified (vf,yf)
% using FOPCB; s=[u v y]';                             8/97, 5/28/02
%
global g vf yf; yf=.2; vf=0; g=1/3;
sf=[.4934 0 .2 0]; nu=[-2.7882 8.4952]; tf=1; s0=zeros(4,1);
p0=[sf nu]; optn=optimset('Display','Iter','MaxIter',500); 
name='tdpcg'; p=fsolve('fopcb',p0,optn,name,s0,tf);
[f,t,y]=fopcb(p,name,s0,tf); u=y(:,1); v=y(:,2); y1=y(:,3);
x=y(:,4); lv=y(:,6); th=180*atan(lv)/pi; N=length(t); 
%
figure(1); clf; plot(x,y1,x(1),y1(1),'ro',0,0,'ro'); grid
xlabel('x/gt_f^2'); ylabel('y/gt_f^2'); axis([-.04 .24 0 .21])
%
figure(2); clf; subplot(211), plot(t,th); ylabel('\theta (deg)')
grid; subplot(212), plot(t,u,t,v,'r--'); grid; xlabel('t/t_f')
legend('u/gt_f','v/gt_f',2)


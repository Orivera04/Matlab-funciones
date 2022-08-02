% Script p3_6_09f.m; TDP for max uf with gravity & specified (vf,yf)
% using FOPCF; s=[u v y x]';                          4/97, 6/22/98
%
global g vf yf; yf=.2; vf=0; g=1/3;
la0=[1 5.707 8.495 0]; nu=[-2.788 8.495]; tf=1; s0=zeros(4,1);
p0=[la0 nu]; optn=optimset('Display','Iter','MaxIter',15); 
name='tdpcg'; p=fsolve('fopcf',p0,optn,name,s0,tf);
[f,t,y]=fopcf(p,name,s0,tf); u=y(:,1); v=y(:,2); y1=y(:,3); 
x=y(:,4); lv=y(:,6); th=180*atan(lv)/pi; N=length(t);
%
figure(1); clf; plot(x,y1,x(N),y1(N),'ro',0,0,'ro'); grid
xlabel('x/at_f^2'); ylabel('y/at_f^2'); axis([-.04 .24 0 .21])
%
figure(2); clf; subplot(211), plot(t,th); grid; ylabel('\theta (deg)')
subplot(212), plot(t,u,t,v,'r--'); grid; xlabel('t/t_f')
legend('u/at_f','v/at_f',2);


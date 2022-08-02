% Script p3_6_10f.m; TDP for max uf with gravity and spec. (vf,yf,xf)
% using FOPCF; s=[u v y x]';                            4/97, 5/28/02
%
clear; clear global; global vf yf xf g; vf=0; yf=.2; xf=.15; g=1/3;
la0=[-.074 2.976 4.623 -1.074]; s0=zeros(4,1); tf=1; 
optn=optimset('Display','Iter','MaxIter',500); 
nu=[-1.647 4.623 -1.074]; p0=[la0 nu]; name='tdpcgx'; 
p=fsolve('fopcf',p0,optn,name,s0,tf);
[f,t,y]=fopcf(p,name,s0,tf); u=y(:,1); v=y(:,2); y1=y(:,3);
x=y(:,4); lu=y(:,5); lv=y(:,6); th=180*atan2(lv,lu)/pi; N=length(t); 
%
figure(1); clf; plot(x,y1,x(N),y1(N),'ro',0,0,'ro'); grid
axis([-.05 .23 0 .21]); xlabel('x/at_f^2'); ylabel('y/at_f^2')
%
figure(2); clf; subplot(211), plot(t,th); grid; ylabel('\theta (deg)')
subplot(212), plot(t,u,t,v,'r--'); grid; xlabel('t/t_f')
legend('u/at_f','v/at_f',2)

	
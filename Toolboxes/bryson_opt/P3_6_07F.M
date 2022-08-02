% Script p3_6_07f.m; TDP for max uf and specified (vf,yf,xf) using FOPCF;
% s=[u v y x]';                                             4/97, 5/28/02
%
clear; clear global; global vf yf xf; vf=0; xf=.15; yf=.2;
la0=[-.2139 .8482 2.0237 -1.2139]; s0=zeros(4,1); tf=1;  
nu=[-1.1755 2.0237 -1.2139]; p0=[la0 nu]; name='tdpcx'; 
optn=optimset('Display','Iter','MaxIter',15); 
p=fsolve('fopcf',p0,optn,name,s0,tf);
[f,t,y]=fopcf(p,name,s0,tf); u=y(:,1); v=y(:,2); y1=y(:,3);
x=y(:,4); lu=y(:,5); lv=y(:,6); th=180*atan2(lv,lu)/pi; N=length(t); 
%
figure(1); clf; plot(x,y1,x(N),y1(N),'ro',0,0,'ro'); grid
xlabel('x/at_f^2'); ylabel('y/at_f^2'); axis([-.05 .23 0 .21])
%
figure(2); clf; subplot(211), plot(t,th); grid; ylabel('\beta (deg)')
subplot(212), plot(t,u,t,v,'r--'); grid; xlabel('t/t_f') 
legend('u/at_f','v/at_f',2)

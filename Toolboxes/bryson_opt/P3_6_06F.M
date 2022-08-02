% Script p3_6_06f.m; TDP for max uf and specified (vf,yf) using FOPCF;
% s=[u v y x]';                                          4/97, 5/28/02
%
clear; clear global; global yf; yf=.2; la0=[1 2.3601 4.7205 0];
nu=[-2.3604 4.7205]; s0=zeros(4,1); tf=1; p0=[la0 nu]; name='tdpc';
optn=optimset('Display','Iter','MaxIter',15); 
p=fsolve('fopcf',p0,optn,name,s0,tf);
[f,t,y]=fopcf(p,name,s0,tf); u=y(:,1); v=y(:,2); y1=y(:,3);
x=y(:,4); lv=y(:,6); c=180/pi; th=c*atan(lv); N=length(t); 
%
figure(1); clf; plot(x,y1,x(N),y1(N),'ro',0,0,'ro'); grid
axis([0 .36 0 .27]); xlabel('x/at_f^2'); ylabel('y/at_f^2')
%
figure(2); clf; subplot(211), plot(t,th); grid
ylabel('\theta (deg)'); subplot(212), plot(t,u,t,v,'r--'); grid
xlabel('t/tf'); legend('u/at_f','v/at_f',2)

% Script p3_6_06n.m; TDP for max uf and spec. (vf,yf) using FOPCN;
% s=[u v y x]';                                      2/97, 5/28/02
%
clear; clear global; global yf; yf=.2; name='tdpc'; 
th0=[1:-.05:-1]; s0=zeros(4,1); tf=1; nu=[-2.3604 4.7205];
p0=[th0 nu]; N=length(th0)-1; t=tf*[0:1/N:1]; 
optn=optimset('Display','Iter','MaxIter',15); 
p=fsolve('fopcn',p0,optn,name,s0,tf); N1=N+1;
[f,s,th,la0]=fopcn(p,name,s0,tf); u=s(1,:); v=s(2,:); y=s(3,:);
x=s(4,:); c=180/pi;  
%
figure(1); clf; plot(x,y,x(N1),y(N1),'ro',0,0,'ro'); grid
axis([0 .36 0 .27]); xlabel('x/at_f^2'); ylabel('y/at_f^2')
%
figure(2); clf; subplot(211), plot(t,th/c); grid
ylabel('\theta (deg)'); subplot(212), plot(t,u,t,v,'r--'); 
grid; xlabel('t/t_f'); legend('u/at_f','v/at_f',2)




	
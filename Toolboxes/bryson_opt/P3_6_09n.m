% Script p3_6_09n.m; TDP for max uf with gravity and spec. (vf,yf)
% using FOPCN; s=[u v y x]'; g=a/3;                  2/97, 5/28/02
%
clear; clear global; global vf yf g; vf=0; yf=.2; g=1/3; 
name='tdpcg'; th0=[1.4:-.1:-1.2]; nu=[-2.828 8.624]; p0=[th0 nu];
N=length(th0)-1; tf=1; t=tf*[0:1/N:1]; s0=zeros(4,1);
optn=optimset('Display','Iter','MaxIter',150); 
p=fsolve('fopcn',p0,optn,name,s0,tf); 
[f,s,th,la0]=fopcn(p,name,s0,tf); u=s(1,:); v=s(2,:);
y=s(3,:); x=s(4,:); c=180/pi; N1=N+1; 
%
figure(1); clf; plot(x,y,x(N1),y(N1),'ro',0,0,'ro'); grid
xlabel('x/at_f^2'); ylabel('y/at_f^2'); axis([-.04 .24 0 .21])
%
figure(2); clf; subplot(211), plot(t,c*th); ylabel('\theta (deg)')
grid; subplot(212), plot(t,u,t,v,'r--'); grid; xlabel('t/t_f')
legend('u/at_f','v/at_f',2)


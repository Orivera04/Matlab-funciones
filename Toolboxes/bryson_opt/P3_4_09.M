% Script p3_4_09.m; TDP for max uf with gravity and spec. (
% vf,yf); s=[u v y x]';                          2/97, 6/16/02
%
clear; clear global; global vf yf g; vf=0; yf=.2; g=1/3;
name='tdpcg'; th0=[1.4:-.1:-1.2]'; N=length(th0)-1; tf=1; 
tu=tf*[0:1/N:1]'; s0=zeros(4,1); k=-.1; told=1e-5; tols=1e-4;
mxit=20; [t,th,s]=fopc(name,tu,th0,tf,s0,k,told,tols,mxit); 
u=s(:,1); v=s(:,2); y=s(:,3); x=s(:,4); N1=length(t); 
%
figure(1); clf; plot(x,y,x(N1),y(N1),'ro',0,0,'ro'); grid
xlabel('x/at_f^2'); ylabel('y/at_f^2'); axis([-.04 .24 0 .21])
%
figure(2); clf; subplot(211), plot(t,180*th/pi); grid
ylabel('\theta (deg)'); axis tight; subplot(212)
plot(t,u,t,v,'r--'); grid; xlabel('t/t_f'); axis tight
legend('u/at_f','v/at_f',2)
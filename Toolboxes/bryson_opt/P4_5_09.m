% Script p4_5_09.m; TDP for min tf to vf=0 and spec. (uf,yf) with
% gravity;  s=[u v y x]'; (u,v) in uf, (x,y) in uf^2/a, t in uf/a;
%                                                    2/97, 7/16/02
%
clear; clear global; global yf g; yf=.2/(.4935)^2; g=1/3;  
name='tdpgt'; th0=[1:-.1:-1]'; N=length(th0)-1; tf=1/.4935;
tu=tf*[0:1/N:1]'; c=180/pi; s0=zeros(4,1); k=1;
told=1e-4; tols=1e-4; mxit=10; 
[t,th,s,tf,nu,la0]=fopt(name,tu,th0,tf,s0,k,told,tols,mxit);
u=s(:,1); v=s(:,2); y=s(:,3); x=s(:,4);
N1=length(u); th=th*c;
%
figure(1); clf; plot(x,y,x(N1),y(N1),'ro',0,0,'ro'); grid;
xlabel('ax/uf^2'); ylabel('ay/uf^2'); axis([-.1 1.1 0 .9]); 
%
figure(2); clf; subplot(211), plot(t,th); grid 
ylabel('\theta (deg)'); axis([0 2.1 -100 100]); subplot(212),
plot(t,u,t,v,'r--'); grid; axis([0 2.1 0 1]); xlabel('t/tf')
legend('u/uf','v/uf',2)
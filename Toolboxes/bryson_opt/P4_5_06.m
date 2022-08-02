% Script p4_5_06.m; TDP for min time to vf=0 and specified (uf,yf);
% s=[u v y x]'; (u,v) in units of uf,(x,y) in uf^2/a, t in uf/a; 
%                                                     2/97, 7/16/02
%
clear; clear global; global yf; yf=.2/.6753^2;  name='tdpt';
th0=[1:-.1:-1]'; N=length(th0)-1; tf=1/.6753; k=1; 
tu=tf*[0:1/N:1]'; s0=zeros(4,1); told=1e-3; tols=1e-3; mxit=7;
[t,th,s,tf]=fopt(name,tu,th0,tf,s0,k,told,tols,mxit);
u=s(:,1); v=s(:,2); y=s(:,3); x=s(:,4); c=180/pi; 
N1=length(u); th=th*c;
%
figure(1); clf; plot(x,y,x(N1),y(N1),'ro',0,0,'ro'); grid
xlabel('ax/u_f^2'); ylabel('ay/u^2'); axis([0 .8 0 .6])
%
figure(2); clf; subplot(211), plot(t,th); grid; 
ylabel('\theta (deg)'); subplot(212), plot(t,u,t,v,'r--'); grid
xlabel('at/u_f'); legend('u/u_f','v/u_f',2); axis([0 1.5 0 1])

	
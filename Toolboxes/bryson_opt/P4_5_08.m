% Script p4_5_08.m; TDP for min tf with gravity and spec. xf, yf, 
% V0, ga0; (u,v) in V0, (x,y) in V0^2/2a, t in V0/a;  s=[u v x y]';
%                                                     2/97, 7/16/02
%
clear; clear global; global yf xf g; xf=1; yf=.1; g=1/3; c=pi/180;  
name='tdpgit'; N=20; ga0=c*45; tf=1.08; th0=c*120*ones(N+1,1);
tu=tf*[0:1/N:1]'; s0=[cos(ga0) sin(ga0) 0 0]'; k=.4; told=1e-5; 
tols=1e-4; mxit=10; 
[t,th,s,tf,nu,la0]=fopt(name,tu,th0,tf,s0,k,told,tols,mxit);
u=s(:,1); v=s(:,2); x=s(:,3); y=s(:,4); N1=length(u); th=th/c;
%
figure(1); clf; plot(x,y,x(N1),y(N1),'ro',0,0,'ro'); grid;
axis([0 1.1 0 .75*1.1]); xlabel('2ax/V_0^2'); ylabel('2ay/V_0^2');
%
figure(2); clf; subplot(211); plot(t,th); grid;
ylabel('\theta (deg)'); axis([0 1.2 0 150]); subplot(212),
plot(t,u,t,v,'r--'); grid; axis([0 1.2 -1 1]); xlabel('at/V0');
legend('u/V_0','v/V_0',3);

	
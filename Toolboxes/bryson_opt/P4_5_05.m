% Script p4_5_05.m; TDP for min tf to yf=0 with spec. xf, V0, ga0; 
% (u,v) in V0, (x,y) in V0^2/2a, t in V0/a; s=[u v x y]'; 2/97, 7/16/02
%
clear; clear global; global xf; xf=.9; name='tdpit'; c=pi/180;
ga0=c*13.8; N=20; tf=.5; tu=tf*[0:1/N:1]'; u=c*100*ones(N+1,1); 
s0=[cos(ga0) sin(ga0) 0 0]'; k=.3; told=1e-4; tols=1e-4; mxit=15;
[t,th,s,tf,nu,la0]=fopt(name,tu,u,tf,s0,k,told,tols,mxit); 
u=s(:,1); v=s(:,2); x=s(:,3); y=s(:,4); N1=length(u); th=th/c;
%
figure(1); clf; plot(x,y,x(N1),y(N1),'ro',0,0,'ro'); grid;  
axis([0 1 -.35 .4]); xlabel('2ax/V_0^2'); ylabel('2ay/V_0^2');
%
figure(2); clf; subplot(211); plot(t,th); grid; ylabel('\theta (deg)');
axis([ 0 .5 0 110]); subplot(212), plot(t,u,t,v,'r--'); grid;
xlabel('at/V_0'); legend('u/V_0','v/V_0',2);
% Script p3_4_05.m; TDP for max xf and yf=0; (u,v) in a*tf, 
% (x,y) in a*tf^2, t in tf; s=[u v x y]';     2/97, 7/16/02
%
name='tdpic'; u0=.5/sqrt(2); v0=u0; c=pi/180; N=20; 
tu=[0:1/N:1]'; th0=-(pi/4)*ones(N+1,1); s0=[u0 v0 0 0]'; 
tf=1; k=-.5; told=1e-5; tols=1e-4; mxit=100;
[t,th,s]=fopc(name,tu,th0,tf,s0,k,told,tols,mxit);
u=s(:,1); v=s(:,2); x=s(:,3); y=s(:,4); N1=length(t); 
%
figure(1); clf; plot(x,y,x(N1),y(N1),'ro',0,0,'ro'); grid 
axis([0 .9 -.75*.4 .75*.5]); xlabel('x/at_f^2') 
ylabel('y/at_f^2')
%
figure(2); clf; subplot(211); plot(t,th/c); grid
ylabel('\theta (deg)'); axis([0 1 -50 0])
subplot(212), plot(t,u,t,v,'r--'); grid; xlabel('t/t_f')
legend('u/at_f','v/at_f',2)
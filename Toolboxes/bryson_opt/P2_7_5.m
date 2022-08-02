% Script p2_7_5.m; VDP for max range with gravity, thrust,
% and specified yf; a=g;                            7/3/02
%
global a yf sy; a=1; yf=.3; sy=2e2; 
load p2_7_5; %tu=tf*[0:1/N:1]'; u0=.4*ones(N+1,1); 
name='vdpt0y'; N=40; tf=1; 
s0=[0 0 0]'; k=-3e-3; told=1e-4; tols=1e-4; mxit=100;
[t,u,s,la0]=fop0(name,tu,u0,tf,s0,k,told,tols,mxit);             
x=s(:,2); y=s(:,3); N2=length(x);
%
figure(1); clf; plot(x,-y,x(N2),-y(N2),'ro',0,0,'ro'); 
grid; axis([0 .8 -.5 .1]); xlabel('x'); ylabel('y')

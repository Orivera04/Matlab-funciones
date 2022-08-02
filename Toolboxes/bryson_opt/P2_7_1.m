% Script p2_7_1.m; VDP for max range w. gravity & specified yf using
% a penalty function; dual of brach. Pb.) w. FOP0;            7/7/02
%
global yf sy; yf=.3; sy=2e2; load p2_7_1; name='vdp0y'; N=20; tf=1;
%tu=tf*[0:1/N:1]'; u=.4*ones(N+1,1); 
s0=[0 0 0]'; k=-1e-2; told=1e-4; tols=1e-4; mxit=10;
[t,u,s,la0]=fop0(name,tu,u0,tf,s0,k,told,tols,mxit);
x=s(:,2); y=s(:,3); N1=length(x);
%
figure(1); clf; plot(x,-y,x(N1),-y(N1),'ro',0,0,'ro'); grid
axis([0 .4 -.32 0]); xlabel('x'); ylabel('y')

	
% Script p2_4_1.m; VDP for max range with gravity; dual of 
% brachistochrone Pb.) w. FOP0;          8/97, 6/98, 3/13/02
%
name='vdp0'; N=20; tf=1; tu=tf*[0:1/N:1]'; u=.4*ones(N+1,1); 
s0=[0 0 0]'; k=-1; told=1e-4; tols=1e-5; mxit=10;
[t,u,s,la0]=fop0(name,tu,u,tf,s0,k,told,tols,mxit);
x=s(:,2); y=s(:,3); N1=length(x);
%
figure(1); clf; plot(x,-y,x(N1),-y(N1),'ro'); grid;
axis([0 .36 -.27 0]); xlabel('x'); ylabel('y');

	
% Script p2_6_1f.m; VDP for max range with gravity using FOP0F; dual 
% of Brach. Pb.;			                       	   3/97, 6/30/02
%
s0=[0 0 0]'; tf=1; la0=[.6366 1 0]; p0=la0; name='vdp0'; 
optn=optimset('Display','Iter','MaxIter',100);
p=fsolve('fop0f',p0,optn,name,s0,tf);
[f,t,y1]=fop0f(p,name,s0,tf); x=y1(:,2); y=y1(:,3); N=length(t);
%
figure(1); clf; plot(x,-y,x,-y,'.',x(1),-y(1),'ro',x(N),-y(N),'ro'); 
grid; axis([0 .36 -.27 0]); xlabel('x'); ylabel('y');

	
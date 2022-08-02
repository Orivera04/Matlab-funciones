% Script p2_6_1b.m; VDP for max range with gravity using FOP0B 
% (dual of Brach. Pb.);	                         3/97, 6/30/02
%
s0=[0 0 0]'; tf=1; sf=[.6366 .3183 .2026]'; name='vdp0';
optn=optimset('Display','Iter','MaxIter',100);
sf=fsolve('fop0b',sf,optn,name,s0,tf);
[f,t,y1]=fop0b(sf,name,s0,tf);x=y1(:,2); y=y1(:,3); 
N=length(t);
%
figure(1); clf; plot(x,-y,x,-y,'.',x(1),-y(1),'ro',x(N),...
    -y(N),'ro'); grid; axis([0 .36 -.27 0]); xlabel('x')
ylabel('y')

	
% Script p2_6_5b.m; VDP for max range w. gravity & thrust using FOP0B;
%                                                        3/97, 6/30/02
%
sf=[1.500 .750 .281]'; s0=[0 0 0]'; tf=1; name='vdpt0'; 
optn=optimset('Display','Iter','MaxIter',100);
sf=fsolve('fop0b',sf,optn,name,s0,tf);
[f,t,y]=fop0b(sf,name,s0,tf); x=y(:,2); y1=y(:,3); N=length(t);
%
figure(1); clf; plot(x,-y1,x,-y1,'b.',x(N),-y1(N),'ro',0,0,'ro');
grid; axis([0 .8 -.6 0]);  xlabel('x'); ylabel('y')

	
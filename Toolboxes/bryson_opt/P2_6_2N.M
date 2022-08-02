% Script p2_6_2n.m; VDP for min distance to a  meridian on a 
% sphere using FOP0N;                          4/97, 6/30/02
%
N=20; u=.5*ones(1,N); tf=2; s0=[0 0]'; name='zrm0'; 
optn=optimset('Display','Iter','MaxIter',500);
u=fsolve('fop0n',u,optn,name,s0,tf);
[f,s,la0]=fop0n(u,name,s0,tf); x=s(1,:); y=s(2,:);  
%
figure(1); clf; plot(x,y,x,y,'.',x(N),y(N),'ro',0,0,'ro'); 
grid; axis([0 3 0 .75*3]); xlabel('x/h'); ylabel('y/h')

	
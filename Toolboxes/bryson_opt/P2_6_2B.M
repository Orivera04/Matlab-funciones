% Script p2_6_2b.m; max range with uc=Vy/h using FOP0B;
%                                                 4/97, 6/30/02
tf=2; sf=[2.9579 1.2361]'; s0=[0 0]'; name='zrm0'; 
optn=optimset('Display','Iter','MaxIter',100);
sf=fsolve('fop0b',sf,optn,name,s0,tf);
[f,t,y]=fop0b(sf,name,s0,tf); x=y(:,1); y1=y(:,2); N=length(t); 
%
figure(1); clf; plot(x,y1,x,y1,'.',x(N),y1(N),'ro',0,0,'ro'); 
grid; axis([0 3 0 .75*3]); xlabel('x/h'); ylabel('y/h')

	
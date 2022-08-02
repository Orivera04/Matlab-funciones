% Script p2_6_2f.m; max range for uc=Vy/h using FOP0F;
%                                            4/97, 6/30/02
tf=2; la0=[1 2]; s0=[0 0]'; name='zrm0';
optn=optimset('Display','Iter','MaxIter',100);
la0=fsolve('fop0f',la0,optn,name,s0,tf);
[f,t,y1]=fop0f(la0,name,s0,tf); x=y1(:,1); y=y1(:,2);
N=length(t); 
%
figure(1); clf; plot(x,y,x,y,'.',x(N),y(N),'ro',0,0,'ro');
grid; axis([0 3 0 .75*3]); xlabel('x/h'); ylabel('y/h')

	
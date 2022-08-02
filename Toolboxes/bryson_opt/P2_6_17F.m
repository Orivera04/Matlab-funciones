% Script p2_6_17f.m; TDP for max orbital radius, Earth to Mars using
% FOP0F, linearized state eqns. (nonlinear in control); s=[r u v]'; 
%                                                            8/23/02
%
name='marslin0'; tf=3.35; s0=[0 0 0]'; la0=[2.2863 .9724 2.5657];
optn=optimset('Display','Iter','MaxIter',500,'TolFun',1e-5);
la0=fsolve('fop0f',la0,optn,name,s0,tf);
[f,t,y]=fop0f(la0,name,s0,tf); N=length(t); un=ones(N,1);
r=y(:,1); u=y(:,2); v=y(:,3); rf=1+r(N);
th=cumtrapz(t,(un+v)./(un+r)); xc=(un+r).*cos(th); 
yc=(un+r).*sin(th);
th1=(pi/90)*[0:90]; co=cos(th1); si=sin(th1);
be=atan2(y(:,5),y(:,6));
for i=1:N, if be(i)<0, be(i)=be(i)+2*pi; end; end
%
figure(1); clf; plot(xc,yc,xc(N),yc(N),'ro',0,...
  0,'ro',co,si,'r--',rf*co,rf*si,'r--',1,0,'ro'); 
grid; axis([-2 2 -.5 2.5]); ylabel('y/r_e') 
xlabel('x/r_e'); text(-.6,.65,'Earth Orbit')
text(-.1,.1,'Sun'); text(.9,1.3,'Mars Orbit')
%
figure(2); clf; plot(t,un+r,t,u,t,un+v); grid
legend('1+r','u','1+v',2); xlabel('Time')
%
figure(3); clf; plot(t,180*be/pi); grid
ylabel('\beta (deg)'); xlabel('Time')



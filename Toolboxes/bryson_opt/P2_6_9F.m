% Script p2_6_9f.m; TDP for max orbital radius,
% Earth to Mars using FOP0F; s=[r u v]';   8/19/02
%
global su sv; su=100; sv=su; name='mar0'; 
tf=3.3155; s0=[1 0 1]'; la0=[2.2908 .9513 1.9199];
optn=optimset('Display','Iter','MaxIter',50);
la0=fsolve('fop0f',la0,optn,name,s0,tf);
[f,t,y]=fop0f(la0,name,s0,tf); N=length(t);
r=y(:,1); u=y(:,2); v=y(:,3); rf=r(N);
th=cumtrapz(t,v./r); xc=r.*cos(th); yc=r.*sin(th);
th1=(pi/90)*[0:90]; co=cos(th1); si=sin(th1);
be=atan2(y(:,5),y(:,6));
for i=1:N, if be(i)<0, be(i)=be(i)+2*pi; end; end
%
figure(1); clf; plot(xc,yc,xc(N),yc(N),'ro',0,...
  0,'ro',co,si,'r--',rf*co,rf*si,'r--',1,0,'ro'); 
grid; axis([-1.6 1.6 -.4 2]); ylabel('y/r_e') 
xlabel('x/r_e'); text(-.6,.65,'Earth Orbit')
text(-.1,.1,'Sun'); text(.9,1.3,'Mars Orbit')
%
figure(2); clf; plot(t,u,t,v,t,r); grid
legend('u','v','r',2); xlabel('Time')
%
figure(3); clf; plot(t,180*be/pi); grid
ylabel('\beta (deg)'); xlabel('Time')



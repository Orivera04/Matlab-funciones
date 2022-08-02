% Script p2_6_9B.m; TDP for max orbital radius,
% Earth to Mars using FOP0B; s=[r u v]';     8/16/02
%
global su sv; su=1e4; sv=su; name='mar0'; 
tf=3.3155; s0=[1 0 1]'; sf=[1.5263 .0003 .8092]';
optn=optimset('Display','Iter','MaxIter',10);
sf=fsolve('fop0b',sf,optn,name,s0,tf);
[f,t,y]=fop0b(sf,name,s0,tf); N=length(t); un=ones(N,1);
for i=1:N, t1(i)=t(N+1-i); y1(i,:)=y(N+1-i,:); end
t=t1; y=y1; r=y(:,1); u=y(:,2); v=y(:,3); rf=r(N);
th=cumtrapz(t,v./r); xc=r.*cos(th); yc=r.*sin(th);
th1=(pi/90)*[0:90]; co=cos(th1); si=sin(th1);
be=atan2(y1(:,5),y1(:,6));
for i=1:N, if be(i)<0, be(i)=be(i)+2*pi; end; end
%
figure(1); clf; plot(xc,yc,xc(N),yc(N),'ro',0,0,...
   'ro',co,si,'r--',rf*co,rf*si,'r--',1,0,'ro'); 
grid; axis([-1.6 1.6 -.4 2]); ylabel('y/r_e') 
xlabel('x/r_e'); text(-.6,.65,'Earth Orbit')
text(-.1,.1,'Sun'); text(.9,1.3,'Mars Orbit')
%
figure(2); clf; plot(t,u,t,v,t,r); grid
legend('u','v','r',2); xlabel('Time')
%
figure(3); clf; plot(t,180*be/pi); grid
ylabel('\beta (deg)'); xlabel('Time')



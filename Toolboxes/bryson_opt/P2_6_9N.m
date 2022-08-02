% Script p2_6_9N.m; TDP for max orbital radius,
% Earth to Mars using FOP0N; s=[r u v]';     8/16/02
%
clear; clear global; global su sv; su=1e4; sv=su;
name='mar0'; tf=3.3155; s0=[1 0 1]'; load p2_6_9n;
optn=optimset('Display','Iter','MaxIter',1);
be=fsolve('fop0n',be0,optn,name,s0,tf); 
[f,s,la0]=fop0n(be,name,s0,tf); N=101; 
r=s(1,:); u=s(2,:); v=s(3,:); rf=r(N); t=tf*[0:.01:1];
th=cumtrapz(t,v./r); xc=r.*cos(th); yc=r.*sin(th);
th1=(pi/90)*[0:90]; co=cos(th1); si=sin(th1);
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



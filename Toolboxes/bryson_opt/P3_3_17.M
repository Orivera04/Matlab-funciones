% Script p3_3_17.m; TDP for max radius orbit transfer with small 
% change in radius; uses FSOLVE to find constants in analytical 
% optimal control to satisfy terminal constraints; s=[r u v]';
%                                                   2/97, 8/24/02
%
p0=[1.7 .15]; optn=optimset('Display','Iter'); 
p=fsolve('marslin',p0,optn); [f,y,s,be]=marslin(p); N=100;
un=ones(N+1,1); r=un+s(:,1); u=s(:,2); v=un+s(:,3); 
tf=3.35; t=tf*[0:1/N:1]; th=cumtrapz(t,v./r); 
xc=r.*cos(th); yc=r.*sin(th); rf=r(N);
th1=(pi/90)*[0:90]; co=cos(th1); si=sin(th1);
%
figure(1); clf; plot(xc,yc,xc(N),yc(N),'ro',0,0,'ro',co,...
   si,'r--',rf*co,rf*si,'r--',1,0,'ro'); grid
axis([-2 2 -.5 2.5]); ylabel('y/r_e') ; xlabel('x/r_e')
text(-.6,.65,'Earth Orbit'); text(-.1,.1,'Sun')
text(.9,1.3,'Mars Orbit')
%
figure(2); clf; plot(t,r,t,u,t,v); grid; axis([0 tf 0 1.6])
legend('1+r','u','1+v',2); xlabel('t')
%
figure(3); clf; plot(t,be*180/pi); grid; ylabel('\beta (deg)')
axis([0 tf 0 360]); xlabel('t')

	
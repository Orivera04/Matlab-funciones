% Script p2_7_9.m; max radius orbit transfer, given tf, using FOP0
% with penalty fcn. on term. constraints; Earth to Mars;   8/16/02
%
global su sv; su=50; sv=su;
load p2_7_9; name='mar0'; tf=3.3155; s0=[1 0 1]';
k=-1e-1; told=1e-7; tols=1e-7; mxit=5; 
[t,be,s,la0,Hu]=fop0(name,tu,be0,tf,s0,k,told,tols,mxit); 
r=s(:,1); u=s(:,2); v=s(:,3); N=length(t); rf=r(N);
th=cumtrapz(t,v./r); x=r.*cos(th); y=r.*sin(th);
th1=(pi/90)*[0:90]; co=cos(th1); si=sin(th1);
%
figure(1); clf; plot(x,y,x(N),y(N),'ro',0,0,'ro',...
   co,si,'r--',rf*co,rf*si,'r--',1,0,'ro'); grid
axis([-1.6 1.6 -.4 2]); ylabel('y/r_e') 
xlabel('x/r_e'); text(-.6,.65,'Earth Orbit')
text(-.1,.1,'Sun'); text(.9,1.3,'Mars Orbit')
%
figure(2); clf; plot(t,u,t,v,t,r); grid; legend('u','v','r',2)
xlabel('Time')
%
figure(3); clf; plot(t,180*be/pi); grid; ylabel('\beta (deg)')
xlabel('Time')


   
% Script p8_7_9.m; max radius transfer in given time using FOP0N2 with
% penalty fcn. on term. constraints; Earth to Mars;             6/30/02
%
load p2_4_8; name='mar0'; tf=3.3155; s0=[1 0 1 0]'; k=-.01; told=1e-5;
tols=5e-4; mxit=3; [tu,uf,s]=fop0(name,tu,be0,tf,s0,k,told,tols,mxit);
tol=1e-3; mxit=0;
[t,be,s,K]=fop0n2(name,tu,uf,s0,tf,tol,mxit); r=s(:,1); u=s(:,2);
v=s(:,3); th=s(:,4); N1=length(t); rf=r(N1); x=r.*cos(th);
y=r.*sin(th); al=(pi/90)*[0:90]; co=cos(al); si=sin(al);
%
figure(1); clf; plot(x,y,x(N1),y(N1),'ro',0,0,'ro',co,si,'r--',...
   rf*co,rf*si,'r--',1,0,'ro'); grid; axis([-1.6 1.6 0 2.7])
ylabel('y/r_e'); xlabel('x/r_e'); text(-.6,.65,'Earth Orbit')
text(-.1,.1,'Sun'); text(.9,1.3,'Mars Orbit')
%
figure(2); clf; plot(t,u,t,v,'r--',t,r,'k-.'); grid
legend('u','v','r',2); xlabel('Time')
%
figure(3); clf; plot(t,180*be/pi); grid; ylabel('\beta (deg)')
xlabel('Time')

   
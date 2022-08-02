% Script e04_5_1.m; TDP for min time to Mars orbit;        9/96, 9/5/02
%
clear; clear global; global rf; rf=1.5237; %be0=[.5:.25:5]; tf=3.33; 
be0=[0.4331 0.5155 0.6131 0.7273 0.8591 1.0086 1.1761 1.3667 1.6190 ...
     2.6625 4.5296 4.7902 4.9362 5.0491 5.1446 5.2290 5.3056 5.3767 ...
     5.4442]'; tf=3.3156;
N=length(be0)-1; tu=tf*[0:1/N:1]'; tf=tu(N,1); name='mart'; 
s0=[1 0 1]'; k=1.5; told=1e-4; tols=3e-3; mxit=50; 
[t,be,s,tf,nu,la0]=fopt(name,tu,be0,tf,s0,k,told,tols,mxit); 
r=s(:,1); u=s(:,2); v=s(:,3); th=cumtrapz(t,v./r); N=length(t); 
rf=r(N); x=r.*cos(th); y=r.*sin(th); ep=ones(N,1)*pi/2+th-be; 
xt=x+.3*cos(ep); yt=y+.3*sin(ep); 
%
figure(1); clf; plot(x,y,x(N),y(N),'ro',0,0,'ro'); grid; hold on
for i=1:91, th1(i)=(i-1)*pi/90; end; co=cos(th1); s=sin(th1); 
plot(co,s,'r--',rf*co,rf*s,'r--',1,0,'ro');
for i=1:2:N, pltarrow([x(i); xt(i)],[y(i); yt(i)],.06,'r','-'); end 
hold off; axis([-1.6 1.6 0 2.4]); ylabel('y/r_e'); xlabel('x/r_e')
text(-.6,.65,'Earth Orbit'); text(-.1,.1,'Sun')
text(.9,1.3,'Mars Orbit')
%
figure(2); clf; plot(t,u,t,v,'r--',t,r,'k-.'); grid 
xlabel('Time'); legend('u','v','r',2) 
%
figure(3); clf; plot(t,180*be/pi); grid; ylabel('\beta (deg)') 
xlabel('Time')


% Script f03_18.m; max radius transfer in given time using FOPC;
% Earth to Mars orbit; s=[r u v]';                   10/96, 9/13/02
%
name='marc'; be=[.5:.125:5.5]'; tf=3.3155; N=length(be)-1; 
tu=tf*[0:1/N:1]'; s0=[1 0 1]'; k=-3; told=1e-5; tols=5e-4; mxit=25; 
[t,be,s,nu,la0]=fopc(name,tu,be,tf,s0,k,told,tols,mxit); 
r=s(:,1); u=s(:,2); v=s(:,3); th=cumtrapz(t,v./r); N1=length(t); 
rf=r(N1); x=r.*cos(th); y=r.*sin(th); ep=ones(N1,1)*pi/2+th-be;
xt=x+.2*cos(ep); yt=y+.2*sin(ep); z=180/pi;
%
figure(1); clf; plot(x,y,x(N1),y(N1),'ro',0,0,'ro'); grid; hold on 
for i=1:91, th1(i)=(i-1)*pi/90; end; co=cos(th1); si=sin(th1);
plot(co,si,'r--',rf*co,rf*si,'r--',1,0,'ro');
for i=1:2:N1, pltarrow([x(i);xt(i)],[y(i);yt(i)],.05,'r','-'); end 
hold off; axis([-1.6 1.6 -.5 2.2]); ylabel('y/r_e') 
xlabel('x/r_e'); text(-.6,.65,'Earth Orbit'); text(-.1,.1,'Sun') 
text(.9,1.3,'Mars Orbit')
%
figure(2); clf; plot(t,u,t,v,t,r); grid
legend('u','v','r',2); xlabel('Time')
%
figure(3); clf; plot(t,z*be,t,z*be,'b.'); grid; ylabel('\beta (deg)')
xlabel('Time')

   
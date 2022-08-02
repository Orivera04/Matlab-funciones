% Script e04_7_1.m; TDP for min tf transfer to Mars orbit using FOPTN;
%                                                             2/97, 9/5/02
%
clear; clear global; global rf; rf=1.5237;
name='mart'; s0=[1 0 1]'; t=[1:19]; be=[.433 .515 .613 .727 .859 ...
  1.009 1.176 1.367 1.620 2.658 4.531 4.790 4.936 5.049 5.144 5.229 ...
  5.305 5.376 5.444]; ti=[1:.5:19]; bei=spline(t,be,ti); tf=3.315;  
nu=[-3.741 3.979 -3.574]; p0=[bei nu tf]; optn=optimset('Display','Iter');
p=fsolve('foptn',p0,optn,name,s0); N1=length(p)-4; be=p([1:N1]);
tf=p(N1+4); [f,s,la0]=foptn(p,name,s0); r=s(1,:); u=s(2,:); v=s(3,:);
N=N1-1; t=tf*[0:1/N:1]; th=cumtrapz(t,v./r); rf=r(1,N1); x=r.*cos(th);
y=r.*sin(th); ep=ones(1,N1)*pi/2+th-be; xt=x+.28*cos(ep);
yt=y+.28*sin(ep); 
%
figure(1); clf; plot(x,y,x(N1),y(N1),'ro',0,0,'ro'); grid; hold on 
for i=1:91, th1(i)=(i-1)*pi/90; end; co=cos(th1);
s=sin(th1); plot(co,s,'r--',rf*co,rf*s,'r--',1,0,'ro');
for i=1:2:N1, pltarrow([x(i);xt(i)],[y(i);yt(i)],.05,'r','-');
end; hold off; axis([-1.6 1.6 0 2.4]); ylabel('y/r_e') 
xlabel('x/r_e'); text(-.6,.65,'Earth Orbit'); text(-.1,.1,'Sun')
text(.9,1.3,'Mars Orbit')
%
figure(2); clf; plot(t,u,t,v,'r--',t,r,'k-.'); grid
legend('u','v','r',2); xlabel('Time')
%
figure(3); clf; plot(t,be*180/pi); grid; ylabel('\beta (deg)')
xlabel('Time')

	
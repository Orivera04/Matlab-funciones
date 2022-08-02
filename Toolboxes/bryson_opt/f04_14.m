% Script f04_14.m; solar sail DP for min time to Mars orbit (H. J.
% Kelley 1962);	                                     11/96, 9/5/02
%
clear; name='martss'; c=180/pi;
th0=[0.3892  0.3513  0.3121  0.2721  0.2325  0.1959  0.1680...
  	 0.1691  0.3701  1.1088  1.2396  1.2490  1.2100  1.1706...
  	 1.1322  1.0962  1.0633  1.0334  1.0063  0.9816  0.9591...
  	 0.9386  0.9197  0.9022  0.8859  0.8708  0.8565  0.8430...
  	 0.8302  0.8180  0.8063  0.7950  0.7841  0.7735  0.7631...
  	 0.7531  0.7432  0.7335  0.7240  0.7148  0.7057]';
tf=6.9924;  N=length(th0)-1; tu=tf*[0:1/N:1]'; mxit=12;
s0=[1 0 1]'; k=.1; told=1e-4; tols=5e-4;
[t,th,s,tf,nu,la0]=fopt(name,tu,th0,tf,s0,k,told,tols,mxit);
r=s(:,1); u=s(:,2); v=s(:,3); ps=cumtrapz(t,v./r); 
N1=length(u); x=r.*cos(ps); y=r.*sin(ps); rf=r(N1);
%
figure(1); clf; plot(x,y,1,0,'ro',x(N1),y(N1),'ro'); grid; hold on
for i=1:181, th1(i)=(i-1)*pi/90; end; plot(cos(th1),sin(th1),...
   '--',0,0,'ro',rf*cos(th1),rf*sin(th1),'--'); t1(N1)=tf*(1-1e-8);
for i=1:2:N1, al=th(i)+ps(i)+pi/2; plot([x(i)-.15*cos(al) ...
    x(i)+.15*cos(al)],[y(i)-.15*sin(al) y(i)+.15*sin(al)]); end
hold off; axis([-1.7 1.7 -1.6 1.6]); axis('square');
ylabel('y'); xlabel('x'); text(-.1,-.1,'Sun')
text(-.8,-.4,'Earth Orbit'); text(-.1,-1.3,'Mars Orbit')
%
figure(2); clf; plot(t,c*th); grid; xlabel('t/tf') 
ylabel('Sail Angle \theta (deg)')
%
figure(3); plot(t,u,t,v,t,r); grid; xlabel('t/t_f')
legend('u','v','r',2); axis tight
	
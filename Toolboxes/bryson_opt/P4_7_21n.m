% Script p4_7_21n.m; solar sail DP for min time to Mars orbit (Henry
% J. Kelley 1962) using FOPTN;	                       2/97, 3/28/02
%
th0=[0.3894  0.3515  0.3123  0.2724  0.2329  0.1965  0.1690...
  	  0.1710  0.3638  1.1163  1.2479  1.2412  1.2082  1.1697...
     1.1316  1.0958  1.0630  1.0332  1.0061  0.9815  0.9590...
     0.9385  0.9196  0.9021  0.8859  0.8707  0.8565  0.8430...
  	  0.8302  0.8180  0.8063  0.7950  0.7841  0.7735  0.7631...
  	  0.7531  0.7432  0.7335  0.7241  0.7148  0.7057];
nu=[-21.3200  8.1077 -45.8535]; tf=6.9924;  p=[th0 nu tf];   
s0=[1 0 1 0]'; c=180/pi; name='martss'; 
optn=optimset('Display','Iter','MaxIter',50);
p=fsolve('foptn',p,optn,name,s0);
[f,s]=foptn(p,name,s0); N1=length(p)-4; th=p([1:N1]);
tf=p(N1+4); r=s(1,:); u=s(2,:); v=s(3,:); ps=s(4,:); t=[0:.025:1];
x=r.*cos(ps); y=r.*sin(ps); rf=r(1,41);
%
figure(1); clf; plot(t,c*th); grid; xlabel('t/tf');
ylabel('Sail Angle \theta (deg)');
%
figure(2); plot(t,s([1:3],:)); grid; xlabel('t/tf');
legend('u','v','r',2);
%
figure(3); clf; plot(x,y,1,0,'ro',x(41),y(41),'ro'); grid; hold on;
for i=1:181, th1(i)=(i-1)*pi/90; end; plot(cos(th1),sin(th1),...
   'r--',0,0,'ro',rf*cos(th1),rf*sin(th1),'r--');
for i=1:2:41, al=th(i)+ps(i)+pi/2; plot([x(i)-.15*cos(al) ...
   x(i)+.15*cos(al)],[y(i)-.15*sin(al) y(i)+.15*sin(al)]); end
hold off; axis([-1.6 1.6 -1.6 1.6]); axis('square');
ylabel('y'); xlabel('x'); text(-.1,-.1,'Sun');
text(-.8,-.4,'Earth Orbit'); text(-.1,-1.3,'Mars Orbit');
	
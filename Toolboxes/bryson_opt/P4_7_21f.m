% Script p4_7_21f.m; solar sail DP for min time to Mars orbit shooting
% soln; (Henry J. Kelley 1962);                    4/97, 3/28/02
%
la0=[-7.5900 -4.4140 -8.2222 0]; tf=6.9923; 
nu=[-21.3261 8.1194 -45.8672]; p0=[la0 nu tf];
s0=[1 0 1 0]'; name='martss';
optn=optimset('Display','Iter','MaxIter',50);
p=fsolve('foptf',p0,optn,name,s0);
[f,t,y]=foptf(p,name,s0); tf=p(8); r=y(:,1); u=y(:,2); v=y(:,3); 
lu=y(:,6); lv=y(:,7); b=lu./lv; c=180/pi;  N=length(t); 
for i=1:N, th(i)=.5*acos((1+b(i)*sqrt(8+9*b(i)^2))/(3*(1+b(i)^2)));
end; ps=y(:,4); x=r.*cos(ps); y1=r.*sin(ps); rf=r(N,1);
%
figure(1); clf; plot(t/tf,c*th); grid; xlabel('t/tf');
ylabel('Sail Angle \theta (deg)'); axis([0 1 0 80]);
%
figure(2); plot(t/tf,y(:,[1:3])); grid; xlabel('t/tf');
legend('u','v','r',2); axis([0 1 -.2 1.6]);
%
figure(3); clf; plot(x,y1,1,0,'ro',x(N),y1(N),'ro'); grid; hold on;
for i=1:181, th1(i)=(i-1)*pi/90; end; plot(cos(th1),sin(th1),...
   'r--',0,0,'ro',rf*cos(th1),rf*sin(th1),'r--');
for i=1:2:N-1, al=th(i)+ps(i)+pi/2; plot([x(i)-.15*cos(al) ...
   x(i)+.15*cos(al)],[y1(i)-.15*sin(al) y1(i)+.15*sin(al)]); end
hold off; axis([-1.6 1.6 -1.6 1.6]); axis('square');
ylabel('y'); xlabel('x'); text(-.1,-.1,'Sun');
text(-.8,-.4,'Earth Orbit'); text(-.1,-1.3,'Mars Orbit');

	
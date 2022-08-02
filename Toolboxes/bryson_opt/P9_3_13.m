% Script p9_3_13.m; minimum time erection of an inverted pendulum 
% with |u|<1; ep=.5; uses switch times & final time as parameters
% (ts) with FMINCON; Fig. 2 is a stroboscopic movie; 4/98, 3/24/02
%
ts=[.6902 .8933 1.0593 2.7212 4.3234 4.9170];  % Converged values
ep=.5; umax=1; optn=optimset('MaxIter',7);
ts=fmincon('ip_f',ts,[],[],[],[],[],[],'ip_c',optn,ep,umax);
[c,ceq,T,x,Tu,u]=ip_c(ts,ep,umax); th=x(:,1); q=x(:,2); y=x(:,3); 
v=x(:,4);
%
figure(1); clf; subplot(211), plot(T,th,'b',T,y,'r--',Tu,u,'k'); 
grid; axis([0 5 -1.2 3.2]); legend('\theta','x/l','f/(M+m)g',2); 
subplot(212), plot(T,q,'b',T,v,'r--'); grid; xlabel('t*sqrt(g/l)');
legend('q','v'); pause(1);
%
n=length(T); tf=T(n); ti=tf*[0:1/50:1]; xi=interp1(T,x,ti);
n1=length(ti); th=xi(:,1); y=xi(:,3); xb=y+sin(th); yb=-cos(th);  
xp=zeros(n1,2); yp=zeros(n1,2); 
for i=1:n1, xp(i,:)=[xb(i) y(i)]; yp(i,:)=[yb(i) 0]; end
%
figure(2); clf; plot([-.78 .98],[0 0]); hold on
plot(0,-1,'ro',[0 0],[0 -1],0,0,'rs'); 
for i=1:n1, plot(xp(i,:),yp(i,:),xb(i),yb(i),'ro',y(i),0,'rs');
   axis([-1.1 1.1 -1.1 1.1]); axis('square'); axis off; pause(.05)
end; hold off 

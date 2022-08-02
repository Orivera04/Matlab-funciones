% Script p4_4_16.m; max time constant-altitude glide to xf=yf=0,
% vf=.3575 (Ping Lu);                              9/97, 3/31/02
%
clear; X0=[-4.5 -3 -1.5 0 1.5 3 4.4]; om=.23; c=180/pi;
P=[.0669 -.0189; .0732 -.0410; .0454 -.0914; -.0514 -.0534; ...
  -.0223 -.0403; .0196 -.0433; .1864 -.0723]; 
Tf=[9.738 9.632 9.560 9.566 9.622 9.528 9.5246];
optn=odeset('RelTol',1e-4); 
for i=1:3, figure(i); clf; end
for i=1:7, s0=[X0(i) 0 1 0]; lx=P(i,1); ly=P(i,2); tf=Tf(i);
 [t,s]=ode23('calgld',[0 tf],s0,optn,lx,ly);
 x=s(:,1); y=s(:,2); v=s(:,3); ps=s(:,4); cp=cos(ps); sp=sin(ps);
 N=length(t); C=ones(N,1)+v.^4/om^2; lp=lx*y-ly*x;
 B=v.^2.*(lx*cos(ps)+ly*sin(ps))-v;
 for i=1:N,
  if abs(sqrt(C(i))*lp(i)/B(i))<1e-3, ts(i)=lp(i)*C(i)/2*B(i);
  else ts(i)=(sign(B(i))*sqrt(B(i)^2+C(i)*(lp(i))^2)-B(i))/lp(i);
 end; end; sg=atan(ts);
 %
 figure(1); plot(x,y); axis([-6.5 5.5 -4.5 4.5]); hold on
 xlabel('x'); ylabel('y')
 %
 figure(2); subplot(211), plot(t,v); hold on; ylabel('v')
 subplot(212),  plot(t,c*ps); hold on; ylabel('\psi (deg)')
 xlabel('Normalized time')
 %
 figure(3); plot(t',sg*c); hold on; ylabel('\sigma (deg)')
 xlabel('Normalized Time'); clear sg x y t v ps ts C B lp;
end
%
figure(1); plot([-6.26 0],[0 0],-6.26,0,'ro',-4.5,0,'ro',-3,0,'ro');
plot(-1.5,0,'ro',0,0,'ro',1.5,0,'ro',3,0,'ro',4.4,0,'ro'); grid 
hold off;
%
figure(2); subplot(211); grid; hold off; subplot(212); grid 
hold off
%
figure(3); grid; text(.7,-70,'x(0)=4.4'); text(.2,-55,'3.0');
text(.2,-41,'1.5'); text(.7,-23,'0'); text(1.1,-8,'-1.5');
text(2.4,3,'-3.0'); text(3.3,-8,'-4.5'); text(4.2,3,'-6.26'); 
hold off
%
figure(4); subplot(211); plot(X0,Tf,'ro',-6.26,9.8474,'o'); 
grid; axis([-7 5 9.5 9.9])


 
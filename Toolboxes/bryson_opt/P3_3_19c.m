% Script p3_3_19c.mm; min fuel holding path; u=tan(ph); (x,y)
% in V^2/g, t in V/g;                              2/92, 3/17/02
%
% LQ approx. soln. for xf <<tf:
xf=10; tf=60; thf=2*pi; om=thf/tf; b=2*xf/tf; t1=tf*[0:.01:1];
un=ones(1,101); q=om*t1; u1=om*(un-b*cos(q)); th1=q-b*sin(q);
y1=(un-cos(q))/om+(b/4)*(un-cos(2*q)); c=180/pi;
ph1=c*atan(u1); x1=sin(q)/om+(b/2)*(t1-sin(2*q)/(2*om)); 
%
% NL soln. w. FSOLVE; find p=(A,C) so that th(tf)=thf, x(tf)=xf:
p0=[om^2 om*(1-b)]; optn=optimset('Display','Iter','MaxIter',50); 
p=fsolve('minfuel',p0,optn,xf,thf,tf);
[f,t,s]=minfuel(p,xf,thf,tf); th=s(:,1); u=s(:,2); x=s(:,3); 
y=s(:,4); ph=c*atan(u); 
%
figure(1); clf; subplot(211), plot(t,ph,t1,ph1,'r--'); grid
axis([0 60 0 9]); legend('Nonlinear','LQ Approx.',4) 
ylabel('Bank Angle \phi (deg)')
subplot(212), plot(t,c*th,t1,c*th1,'r--'); grid
legend('Nonlinear','LQ Approx.',2); xlabel('gt/V')
ylabel('Heading Angle \theta (deg)'); 
%
figure(2); clf; plot(x,y,x1,y1,'r--'); grid; axis([-5 15 0 20])
legend('Nonlinear','LQ Approx.'); axis('square')
xlabel('gx/V^2'); ylabel('gy/V^2')



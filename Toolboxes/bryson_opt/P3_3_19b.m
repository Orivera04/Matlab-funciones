% Script p3_3_19b.m; min fuel holding path; u=tan(sg); (x,y) in 
% V^2/g, t in V/g;                                    2/92, 3/17/02
%
% LQ approx. soln. for tf-xf<<tf:
xf=40; tf=60; thf=0; om=2*pi/tf; D=2*sqrt(1-xf/tf); c=180/pi;  
t1=tf*[0:.01:1]; m=om*t1; u1=om*D*cos(m); th1=D*sin(m);  
y1=D*(ones(1,101)-cos(m))/om; x1=xf*t1/tf+D^2*sin(2*m)/(8*om);
sg1=c*atan(u1); 
%
% NL soln. using FSOLVE; finds p=[A C] so that th(tf)=thf, x(tf)=xf:
p0=[-om^2 D*om]; optn=optimset('Display','Iter','MaxIter',50); 
p=fsolve('minfuel',p0,optn,xf,thf,tf); [f,t,s]=minfuel(p,xf,thf,tf);
th=s(:,1); u=s(:,2); x=s(:,3); y=s(:,4); sg=c*atan(u); 
%
figure(1); clf; subplot(211), plot(t,sg,t1,sg1,'r--'); grid
legend('Nonlinear','LQ Approx.',2); ylabel('Bank Angle \phi (deg)')
subplot(212), plot(t,c*th,t1,c*th1,'r--'); grid
legend('Nonlinear','LQ Approx.'); xlabel('gt/V') 
ylabel('Heading angle \theta (deg)'); 
%
figure(2); clf; plot(x,y,x1,y1,'r--'); grid; xlabel('gx/V^2')
ylabel('gy/V^2'); axis([0 40 0 40]); axis('square')
legend('Nonlinear','LQ Approx.')
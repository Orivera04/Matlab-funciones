% Script p8_5_9.m; max radius transfer in given time using FOP0N2 
% w. penalty fcn. on terminal constraints; Earth to Mars (see 
% e03_6_1, p2_6_9f,b,n, p2_7_9);                          8/21/02
%
clear global; global su sv; su=100; sv=su; name='mar0'; 
load p2_6_9f; tf=3.3155; s0=[1 0 1]'; tol=1e-6; mxit=5;
[t,be,s,K,Hu,Huu]=fop0n2(name,tu,be0,s0,tf,tol,mxit);
r=s(:,1); u=s(:,2); v=s(:,3); N=length(t); rf=r(N);
th=cumtrapz(t',v./r); x=r.*cos(th); y=r.*sin(th);
th1=(pi/90)*[0:90]; co=cos(th1); si=sin(th1);
%
figure(1); clf; plot(x,y,x(N),y(N),'bo',0,0,'bo',co,si,'r--',...
    rf*co,rf*si,'r--',1,0,'ro'); grid; axis([-1.6 1.6 -.4 2])
ylabel('y/r_e'); xlabel('x/r_e'); text(-.6,.65,'Earth Orbit')
text(-.1,.1,'Sun'); text(.9,1.3,'Mars Orbit'); hold on
%
figure(2); clf; plot(t,u,t,v,t,r); grid
legend('u','v','r',2); xlabel('Time'); hold on
%
figure(3); clf; plot(t,180*be/pi); grid
ylabel('\beta (deg)'); xlabel('Time'); hold on
%
figure(4); clf; subplot(211),plot(t,K); grid
legend('K_r','K_u','K_v',3); subplot(212), plot(t,Huu);
grid; ylabel('H_{uu}'); xlabel('Time');
%
% A nbr. opt. path with perturbed ICs:
tn=t; ben=be; sn=s; optn=odeset('RelTol',1e-6); s0=[1 0 1.01]'; 
[t1,s1]=ode23('mar0s',[0 tf],s0,optn,tn,ben,sn,K);
r1=s1(:,1); u1=s1(:,2); v1=s1(:,3); N1=length(t1); 
th1=cumtrapz(t1',v1./r1); x1=r1.*cos(th1); y1=r1.*sin(th1);
figure(1); plot(x1,y1,'r--',x1(N1),y1(N1),'ro'); 
figure(2); plot(t1,u1,'b--',t1,v1,'g--',t1,r1,'r--');
hold off; s1a=interp1(t1,s1,tn); 
for i=1:N, be1(i)=ben(i)-K(i,:)*(s1a(i,:)'-sn(i,:)'); end
figure(3); plot(tn,180*be1/pi,'r--'); hold off 
%
% Exact path with perturbed ICs:
[t2,be2,s2]=fop0n2(name,tn,be1,s0,tf,tol,mxit);
s2a=interp1(t2,s2,t1); be2a=interp1(t2,be2,t1);
be1a=interp1(tn,be1,t1);
r2=s2a(:,1); u2=s2a(:,2); v2=s2a(:,3);  
th2=cumtrapz(t1',v2./r2); x2=r2.*cos(th2); y2=r2.*sin(th2);
figure(1); plot(x2,y2,'r.',x2(N1),y2(N1),'ro'); hold off
figure(5); plot(t1,u2-u1,t1,v2-v1,t1,r2-r1); grid
legend('du','dv','dr',2); xlabel('Time');
figure(6); plot(t1,180*(be2a-be1a)/pi); grid; ylabel('Deg')
ylabel('d\beta (deg)'); xlabel('Time')


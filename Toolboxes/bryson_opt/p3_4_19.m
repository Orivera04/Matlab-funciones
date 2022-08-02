% Script p3_4_19.m; bank angle program for min fuel 
% holding path; s=[th x y J]';                7/16/02
%
tf=60; xf=10; thf=2*pi; name='holdp'; s0=[0 0 0 0]'; 
%tu=[0:5:60]'; u0=.07*ones(13,1)+.07*(sin(pi*tu/tf)).^2; 
load p3_4_19; 
k=-.03; told=1e-5; tols=5e-4; mxit=10;
[t,u,s]=fopc(name,tu,u0,tf,s0,k,told,tols,mxit);
th=s(:,1); x=s(:,2); y=s(:,3); ph=atan(u);
%
figure(1); clf; subplot(211), plot(t,180*ph/pi); grid
axis([0 60 4 9]); ylabel('Bank Angle \phi (deg)')
subplot(212), plot(t,180*th/pi); grid; xlabel('gt/V')
ylabel('Heading Angle \theta (deg)') 
%
figure(2); clf; plot(x,y); grid; axis([-5 15 0 20])
axis('square'); xlabel('gx/V^2'); ylabel('gy/V^2')


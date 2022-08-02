% Script p3_6_08n.m; TDP for max xf with gravity and yf=0 with FOPCN;
% (u,v) in a*tf, (x,y) in a*tf^2/2, t in tf, g in a; s=[u v x y]';
%                                                       2/97, 5/28/02
%
clear; clear global; global yf g; yf=0; g=1/3; name='tdpgic'; tf=1;  
u0=.5/sqrt(2); v0=u0; c=pi/180; N=20; t=tf*[0:1/N:1]; N1=N+1;
th0=-c*21.95*ones(1,N1); nu=-.4030; p0=[th0 nu]; s0=[u0 v0 0 0]';
optn=optimset('Display','Iter','MaxIter',15); 
p=fsolve('fopcn',p0,optn,name,s0,tf); 
[f,s,th,la0]=fopcn(p0,name,s0,tf); u=s(1,:); v=s(2,:); x=s(3,:);
y=s(4,:);  
%
figure(1); clf; plot(x,y,x(N1),y(N1),'ro',0,0,'ro'); grid
axis([0 .9 -.75*.4 .75*.5]); xlabel('x/at_f^2'); ylabel('y/at_f^2')
%
figure(2); clf; subplot(211); plot(t,th/c); grid
ylabel('\theta (deg)'); axis([0 1 -25 0]); subplot(212)
plot(t,u,t,v,'r--'); grid; xlabel('t/t_f')
legend('u/at_f','v/at_f',2)

	
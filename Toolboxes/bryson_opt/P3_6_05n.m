% Script p3_6_05n.m; TDP for max xf and yf=0 using FOPCN; (u,v) in a*tf,
% (x,y) in  a*tf^2, t in tf; s=[u v x y]';                 2/97, 5/28/02
%
clear; clear global; global yf; yf=0; name='tdpic'; u0=.5/sqrt(2); v0=u0;
c=pi/180; N=20; t=[0:1/N:1]; th0=-(pi/4)*ones(1,N+1); s0=[u0 v0 0 0]';
tf=1; nu=-1; p0=[th0 nu]; N=length(th0)-1; t=tf*[0:1/N:1]; 
told=1e-5; tols=5e-4; optn=optimset('Display','Iter','MaxIter',15);
p=fsolve('fopcn',p0,optn,name,s0,tf); N1=N+1;
[f,s,th,la0]=fopcn(p,name,s0,tf); u=s(1,:); v=s(2,:); x=s(3,:); y=s(4,:);  
%
figure(1); clf; plot(x,y,x(N1),y(N1),'ro',0,0,'ro'); grid 
axis([0 .9 -.75*.4 .75*.5]); xlabel('x/at_f^2'); ylabel('y/at_f^2')
%
figure(2); clf; subplot(211); plot(t,th/c); grid
ylabel('\theta (deg)'); axis([0 1 -50 0])
subplot(212), plot(t,u,t,v,'r--'); grid; xlabel('t/t_f')
legend('u/at_f','v/at_f',2)
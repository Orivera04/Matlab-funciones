% Script p3_5_05n.m; DTDP for max xf and spec. yf, u0, v0 using DOP0N;
% (u,v) in a*tf, (x,y) in a*tf^2/2, t in tf;             3/97, 5/27/02
%
N=20; u0=.5/sqrt(2); v0=u0; c=pi/180; tf=1; th=-.5*ones(1,N);
s0=[u0 v0 0 0]'; t=[0:N]/N; name='dtdpic'; 
optn=optimset('Display','Iter','MaxIter',500); nu=-.4030;
p0=[th nu]; p=fsolve('dopcn',p0,optn,name,s0,tf);
[f,s,la0]=dopcn(p,name,s0,tf); th=p([1:N]); thh=[th th(N)]/c;
u=s(1,:); v=s(2,:); x=s(3,:); y=s(4,:); N1=N+1;  
%
figure(1); clf; plot(x,y,0,0,'ro',x(N1),y(N1),'ro'); grid
axis([0 .9 -.75*.4 .75*.5]); xlabel('x/at_f^2'); ylabel('y/at_f^2')
%
figure(2); clf; subplot(211), zohplot(t,thh); grid; 
axis([0 1 -50 0]); ylabel('\theta (deg)')
subplot(212), plot(t,u,t,v,'r--'); grid; xlabel('t/tf')
legend('u/at_f','v/at_f',2)

	
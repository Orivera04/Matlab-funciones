% Script p3_2_08.m; DTDP for max xf with gravity and spec.
% u0,v0,yf using DOP0; (u,v) in a*tf, (x,y) in a*tf^2/2, 
% t in tf, g in a;                          3/97, 3/30/02
%
global yf g; yf=0; g=1; N=20; u0=.5/sqrt(2); v0=u0; tf=1;
c=pi/180; th=c*21.95*ones(1,N); x0=[u0 v0 0 0]'; k=-30; 
tol=5e-5; t=[0:1/N:1]; mxit=100; 
[th,s,nu,la0]=dopc('dtdpgic',th,x0,tf,k,tol,mxit);
u=s(1,:); v=s(2,:); x=s(3,:); y=s(4,:); thh=[th th(N)]/c;
%
figure(1); clf; plot(x,y,x,y,'b.'); grid; ylabel('y/at_f^2')
axis([0 .9 -.75*.4 .75*.5]); xlabel('x/at_f^2'); 	
%
figure(2); clf; subplot(211), zohplot(t,thh); axis([0 1 0 25]);
grid; ylabel('\theta (deg)'); subplot(212), plot(t,u,t,v,'r--')
grid; xlabel('t/t_f'); legend('u/at_f','v/at_f',2);

	
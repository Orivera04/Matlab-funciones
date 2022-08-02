% Script p3_2_05.m; DTDP for max xf with yf=0 and spec.
% u0,v0 using using DOP0; (u,v) in a*tf, (x,y) in a*tf^2,
% t in tf;                                  4/97, 3/30/02
%
N=20; u0=.5/sqrt(2); v0=u0; tf=1; N1=N+1; 
th=-asin(2*v0)*ones(1,N); k=-1; tol=5e-5; s0=[u0 v0 0 0]'; 
mxit=10; [th,s]=dopc('dtdpic',th,s0,tf,k,tol,mxit); 
u=s(1,:); v=s(2,:); x=s(3,:); y=s(4,:); 
thh=[th th(N)]*180/pi; t=tf*[0:1/N:1];
%
figure(1); clf; plot(x,y,x,y,'b.',x(N1),y(N1),'ro'); grid 
axis([0 .9 -.75*.4 .75*.5]); xlabel('x/at_f^2') 
ylabel('y/at_f^2')
%
figure(2); clf; subplot(211), zohplot(t,thh); grid 
axis([0 1 -50 0]); ylabel('\theta (deg)'); subplot(212),
plot(t,u,t,v); grid; xlabel('t/t_f'); 
legend('u/at_f','v/at_f');


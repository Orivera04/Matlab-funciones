% Script p3_2_12.m; DVDP for max xf with gravity, thrust, drag,
% and spec. yf; (x,y) in l, V in sqrt(gl), t in sqrt (l/g);
%                                                   5/97, 3/31/02
%
clear; clear global; global a yf; a=.05; yf=-.3; N=20; c=180/pi;
ga0=-.15*ones(1,N); s0=[0 0 0]'; tf=5; k=-1.2; tol=1e-4; mxit=100; 
[ga,s,nu,la0]=dopc('dvdpctd',ga0,s0,tf,k,tol,mxit); s=real(s);
v=s(1,:); x=s(2,:); y=s(3,:); ke=v.^2/2; gah=c*real([ga ga(N)]);
N1=N+1; t=tf*[0:1/N:1];
%
figure(1); clf; subplot(211); plot(x,y,x(N1),y(N1),'ro',0,0,'ro');
grid; axis([0 2 -.4 0]); ylabel('y/gt_f^2'); xlabel('x/gt_f^2');
subplot(212); plot(ke,y,ke,y,'b.',ke(N1),y(N1),'ro',0,0,'ro');
grid; xlabel('V^2/gl'); ylabel('y/l'); axis([0 .12 -.4 0])
%
figure(2); clf; subplot(211), plot(t,v); grid; ylabel('V');
subplot(212), zohplot(t,gah); grid; xlabel('t*sqrt(l/g)');
ylabel('\gamma (deg)');




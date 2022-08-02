% Script p3_1_05.m; DTDP for max xf with yf=0 and spec.
% V0, ga0; (u,v,V0) in a*tf, (x,y) in a*tf^2, dt=1/N;  
%                                             2/97, 3/30/02
%
N=20; u0=.5/sqrt(2); v0=u0; th=-asin(2*v0); xf=u0+cos(th)/2;
t=[0:1/N:1]; x=t*u0+t.^2*cos(th)/2; y=t*v0+t.^2*sin(th)/2;
un=ones(1,N+1); u=u0*un+t.*cos(th); v=v0+t.*sin(th); 
%
figure(1); clf; plot(x,y,x,y,'.',xf,0,'ro',0,0,'ro'); 
grid; axis([0 .9 -.75*.4 .75*.5]); xlabel('x/at_f^2') 
ylabel('y/at_f^2')
%
figure(2); clf; subplot(211), zohplot(t,th*un*180/pi); 
grid; axis([0 1 -50 0]); ylabel('\theta (deg)') 
subplot(212), plot(t,u,t,v,'r'); grid; xlabel('t/t_f') 
legend('u/at_f',' v/at_f')

	
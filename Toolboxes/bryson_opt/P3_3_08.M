% Script p3_3_08.m; max range to yf=0 with gravity & spec. u0,v0,
% tf,yf; (u,v) in a*tf, (x,y) in a*tf^2, t in tf;      4/97, 3/26/02
%
u0=.5/sqrt(2); v0=u0; c=pi/180; yf=.1; g=1/3; th=asin(g+2*(yf-v0));
c=cos(th); xf=u0+c/2; si=sin(th); t=[0:.01:1]; un=ones(1,101);
x=u0*t+t.^2*c/2; y=v0*t+t.^2*(si-g)/2; u=u0*un+t*c; 
v=v0*un+t*(si-g);
%
figure(1); clf; subplot(211), plot(x,y,x(101),y(101),'ro',0,0,'ro');
grid; axis([0 .9 -.1 .2]); xlabel('x/at_f^2'); ylabel('y/at_f^2')
subplot(212), plot(t,u,t,v,'r--'); grid; xlabel('t/tf')
legend('u/at_f','v/at_f',2)
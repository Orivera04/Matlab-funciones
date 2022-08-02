% Script p3_1_02.m; DVDP for max range with uc=Vy/h and y(tf)=0;
% plots from analytic solution; (x,y) in units of h, t in units 
% of h/V; th0 found from off-line interpolation to give
% th(tf)=thf;                                      1/93, 3/30/02
%	
th0=1.2333; tf=6; N=20; dt=tf/N; x(1)=0; y(1)=0; th(1)=th0;
for i=1:N,
  th(i)=atan(tan(th0)-(i-1)*dt); y(i+1)=y(i)+dt*sin(th(i));
  x(i+1)=x(i)+dt*(y(i)+cos(th(i)))+.5*dt^2*sin(th(i));
end
%
% Location of tips of thrust vectors:
for i=1:N, xt(i)=x(i)+1.5*cos(th(i)); yt(i)=y(i)+1.5*sin(th(i));
end
%
figure(1); clf; plot(x,y,'o',x,y); grid; hold on 
for i=1:N, pltarrow([x(i) xt(i)],[y(i) yt(i)],.3,'r','-'); end
hold off; axis([0 12 -3 6]); xlabel('x/h'); ylabel('y/h')
title('DVDP for Max Range w. uc=Vy/h, yf/h=0, V*tf/h=6')
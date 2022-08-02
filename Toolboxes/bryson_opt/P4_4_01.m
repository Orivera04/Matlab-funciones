% Script p4_4_01.m; VDP for min time to a point with gravity; v in
% sqrt(g*xf), t in sqrt(xf/g), (x,y) in xf; p=2*b*tf; 12/96, 3/29/02
%
clear; clear global; global yf; yf=1/3; p=pi; 
optn=optimset('Display','Iter','MaxIter',100);
p=fsolve('vdpt_f',p,optn); b=.5*sqrt((1-cos(p))/yf);
tf=p/(2*b); t=tf*[0:.025:1]; un=ones(1,41); ga=(pi/2)*un-b*t;
x=(1/(2*b))*(t-sin(2*b*t)/(2*b)); y=(1/(4*b^2))*(un-cos(2*b*t));
%
figure(1); clf; plot(x,-y,1,-1/3,'ro',0,0,'ro'); grid
xlabel('x/x_f'); ylabel('y/x_f'); axis([0 1 -.75 0])

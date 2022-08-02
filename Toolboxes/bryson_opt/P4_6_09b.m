% Script p4_6_09b.n.m; DTDP for min tf with gravity to vf=0 and spec.
% (uf,yf) with DOPTB;	                               3/97, 3/28/02
%
clear; clear global; global yf g; yf=.2/.4935^2; g=1/3; 
sf=[1 0 .8212 .8275]; nu=[-.2567 .7197 -1.0796]; tf=2.0299;
s0=[0 0 0 0]'; N=10; name='dtdpgt'; 
optn=optimset('Display','Iter','MaxIter',5);
p0=[sf nu tf]; uf=-1; p=fsolve('doptb',p0,optn,name,uf,s0,N);
[f,s,th,la]=doptb(p,name,uf,s0,N); tf=p(8); thh=[th th(N)]*180/pi;
t=tf*[0:1/N:1]; u=s(1,:); v=s(2,:); y=s(3,:); x=s(4,:); 
%
% Spline fit to double number of points in (x,y):
ti=tf*[0:.5/N:1]; xi=spline(t,x,ti); yi=spline(t,y,ti);
%
% Calculate coord. of tips of thrust direction arrows:
for i=1:N, xt(i)=x(i)+.15*cos(th(i)); yt(i)=y(i)+.15*sin(th(i)); end
%
figure(1); clf; plot(x,y,'b.',xi,yi,'b'); grid; hold on 
for i=1:N, pltarrow([x(i) xt(i)],[y(i) yt(i)],.024,'r','-'); end
hold off; axis([-.15 1.05 0 .9]); xlabel('ax/u_f^2'); ylabel('ay/u_f^2')
%
figure(2); clf; subplot(211), zohplot(t,thh); grid 
axis([0 2.1 -100 100]); ylabel('Theta (deg)')
subplot(212), plot(t,u,t,v,'r--'); grid; xlabel('at/u_f')
axis([0 2.1 0 1]); legend('u/u_f','v/u_f',2)

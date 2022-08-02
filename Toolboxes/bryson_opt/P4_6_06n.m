% Script p4_6_06n.m; DTDP for min tf to vf=0 and specified (uf,yf) 
% using DOPTN; (u,v) in uf, (x,y) in uf^2/a, t in uf/a;
%                                                 3/97, 3/28/02
%
clear; clear global; global yf; yf=.2/.6753^2; th=[1:-2/9:-1];
s0=[0 0 0 0]'; tf=1/.6750; N=length(th); name='dtdpt'; 
optn=optimset('Display','Iter','MaxIter',50);
nu=[-1.39 .921 -1.244]'; p0=[th nu' tf];
p=fsolve('doptn',p0,optn,name,s0); th=p(1:N); nu=p(N+1:N+3);
[f,s,la0]=doptn(p,name,s0); u=s(1,:); tf=p(N+4); t=tf*[0:.1:1]; 
v=s(2,:); y=s(3,:); x=s(4,:); thh=[th th(10)]*180/pi;
%
% Spline fit to double number of points in (x,y):
ti=tf*[0:.5/N:1]; xi=spline(t,x,ti); yi=spline(t,y,ti);
%
% Coord. tips of thrust direction arrows:
for i=1:N, xt(i)=x(i)+.12*cos(th(i)); yt(i)=y(i)+.12*sin(th(i)); end
%
figure(1); clf; plot(x,y,'b.',xi,yi,'b'); grid; hold on 
for i=1:N, pltarrow([x(i) xt(i)],[y(i) yt(i)],.02,'r','-'); end
hold off; axis([0 .8 0 .6]); xlabel('ax/u_f^2'); ylabel('ay/u_f^2')
%
figure(2); clf; subplot(211), zohplot(t,thh); grid 
ylabel('\theta (deg)'); axis([0 1.5 -100 100])
subplot(212), plot(t,u,t,v,'r--'); grid; xlabel('at/u_f')
axis([0 1.5 0 1]); legend('u/u_f','v/u_f',2) 


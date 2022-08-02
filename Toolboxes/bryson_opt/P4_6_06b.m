% Script p4_6_06b.m; DTDP for min tf to vf=0 and specified (uf,yf) 
% using DOPTB; (u,v) in uf, (x,y) in uf^2/a, t in uf/a;
%                                                  3/97, 3/28/02
%
clear; clear global; global yf; yf=.2/.6753^2; N=10;  
N=10; s0=[0 0 0 0]'; sf=[1 0 .4434 .7445]';
nu=[-.3863 .9257 -1.2434]'; tf=1.4890; uf=-1;
p0=[sf' nu' tf]; name='dtdpt'; 
optn=optimset('Display','Iter','MaxIter',50);
p=fsolve('doptb',p0,optn,name,uf,s0,N);
[f,s,th,la]=doptb(p,name,uf,s0,N); thh=[th th(N)]*180/pi; 
t=tf*[0:1/N:1]; u=s(1,:); v=s(2,:); y=s(3,:); x=s(4,:);
%
% Spline fit to double number of points in (x,y):
ti=tf*[0:.5/N:1]; xi=spline(t,x,ti); yi=spline(t,y,ti);
%
% Coord. tips of thrust direction arrows:
for i=1:N, xt(i)=x(i)+.12*cos(th(i)); yt(i)=y(i)+.12*sin(th(i)); end
%
figure(1); clf; plot(x,y,'b.',xi,yi,'b'); grid; hold on; 
for i=1:N, pltarrow([x(i) xt(i)],[y(i) yt(i)],.02,'r','-'); end;
hold off; axis([0 .8 0 .6]); xlabel('ax/uf^2'); ylabel('ay/uf^2');
%
figure(2); clf; subplot(211), zohplot(t,thh); grid 
ylabel('\theta (deg)'); axis([0 1.5 -100 100])
subplot(212), plot(t,u,t,v,'r--'); grid; xlabel('at/u_f')
axis([0 1.5 0 1]); legend('u/u_f','v/u_f',2) 

 
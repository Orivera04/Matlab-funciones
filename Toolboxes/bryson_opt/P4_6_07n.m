% Script p4_6_07n.m; DTDP for min tf to vf=0 and spec. (uf,yf,xf) using
% DOPTN; (u,v) in uf, (x,y) in uf^2/a, t in uf/a;         3/97, 3/28/02
%
th=[1.911 1.800 1.538 .734 -.233 -.571 -.703 -.771 -.812 -.840];
s0=[0 0 0 0]'; tf=1/.4874; N=length(th); name='dtdptx';
nu=[-.1150 .1310 -.1091 .0737]'; 
optn=optimset('Display','Iter','MaxIter',50);
p0=[th nu' tf]; p=fsolve('doptn',p0,optn,name,s0);
[f,s,la0]=doptn(p,name,s0); th=p([1:N]); thh=[th th(N)]*180/pi;
t=[0:1/N:1]; x=s(4,:); y=s(3,:); u=s(1,:); v=s(2,:);
%
% Spline fit to double number of points in (x,y):
ti=tf*[0:.5/N:1]; xi=spline(t,x,ti); yi=spline(t,y,ti);
%
% Coord. of tips of thrust direction arrows:
for i=1:10, xt(i)=x(i)+.16*cos(th(i)); yt(i)=y(i)+.16*sin(th(i)); end
% 
figure(1); clf; plot(x,y,x,y,'b.'); grid; hold on 
for i=1:N, pltarrow([x(i) xt(i)],[y(i) yt(i)],.02,'r','-'); end
hold off; axis([-.3 .9 0 .9]); xlabel('ax/u_f^2'); ylabel('ay/u_f^2')
%
figure(2); clf; subplot(211), zohplot(t,thh); grid
ylabel('\theta (deg)'); subplot(212), plot(t,u,t,v,'r--'); grid
xlabel('t/t_f'); legend('u/u_f','v/u_f',2)
 	
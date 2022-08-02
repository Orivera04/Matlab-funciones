% Script e03_5_1.m; DTDP for max uf to vf=0 and spec. yf using DOPCN;
%                                                         2/97, 5/27/02
%
N=10; s0=[0 0 0 0]'; tf=1; t=[0:N]/N; name='dtdpc';
optn=optimset('Display','Iter','MaxIter',500);
th0=[1.047 .838 .628 .419 .209 0 -0.209 -.419 -.628 -.838];
nu0=[-2.396 4.792]; p0=[th0 nu0]; p=fsolve('dopcn',p0,optn,name,s0,tf);
[f,s,la0,nu]=dopcn(p,name,s0,tf); th=p([1:N]); 
thh=[th th(N)]; u=s(1,:); v=s(2,:); x=s(4,:); y=s(3,:);
%
% Spline fit to double number of points in (x,y):
ti=[0:.5/N:1]; xi=spline(t,x,ti); yi=spline(t,y,ti);
%
% Coord. of tips of thrust direction arrows:
for i=1:N, xt(i)=x(i)+.06*cos(th(i));  yt(i)=y(i)+.06*sin(th(i)); end
%
figure(1); clf; plot(x,y,'b.',xi,yi,'b'); grid; hold on 
for i=1:N,  pltarrow([x(i) xt(i)],[y(i) yt(i)],.01,'r','-'); end
hold off; axis([0 .35 0 .22]); xlabel('x/at_f^2'); ylabel('y/at_f^2')
%
figure(2); clf; subplot(211), zohplot(t,thh*180/pi);
grid; ylabel('\theta (deg)'); subplot(212), plot(t,u,t,v,'r--'); grid
xlabel('t/t_f'); legend('u/at_f',' v/at_f',2)


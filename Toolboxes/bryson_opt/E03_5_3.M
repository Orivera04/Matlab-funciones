% Script e03_5_3.m; DTDP for max uf to vf=0 and spec. yf using DOPCB;
%                                                          3/97, 6/25/02
%
N=10; s0=[0 0 0 0]'; tf=1; t=tf*[0:N]/N; thf=-.838; sf=[.672 0 .2 .336];
nu=[-2.396 4.792]; p0=[sf nu]; name='dtdpc'; 
optn=optimset('Display','Iter','MaxIter',50);
p=fsolve('dopcb',p0,optn,name,thf,s0,tf,N);
[f,s,th,la]=dopcb(p,name,thf,s0,tf,N); thh=[th th(N)];
u=s(1,:); v=s(2,:); y=s(3,:); x=s(4,:);   
%
% Spline fit to double number of points in (x,y):
ti=[0:.5/N:1]; xi=spline(t,x,ti); yi=spline(t,y,ti);
%
% Coord. of tips of thrust direc. arrows:
for i=1:N, xt(i)=x(i)+.06*cos(th(i)); yt(i)=y(i)+.06*sin(th(i)); end
%
figure(1); clf; plot(x,y,'b.',xi,yi,'b'); grid; hold on 
for i=1:N,  pltarrow([x(i) xt(i)],[y(i) yt(i)],.01,'r','-'); end
hold off; axis([0 .35 0 .22]); xlabel('x/at_f^2');ylabel('y/at_f^2')
%
figure(2); clf; subplot(211), zohplot(t,thh*180/pi);
grid; ylabel('\theta (deg)'); subplot(212), plot(t,u,t,v,'r--'); grid
xlabel('t/t_f'); legend('u/at_f',' v/at_f',2)
        

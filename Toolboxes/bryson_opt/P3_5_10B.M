% Script p3_5_10b.m; DTDP for max uf with gravity and (vf,yf,xf) speci-
% fied using DOPCB; s=[u,v,y,x]'; t in tf, (u,v) in a*tf, (x,y) in
% a*tf^2, g in a;                                        3/97, 5/27/02
%
N=10; s0=[0 0 0 0]'; sf=[.454 0 .2 .15]; t=[0:N]/N; name='dtdpgcx';
nu=[-1.715 4.831 -1.055]; nu=[-1.715 4.831 -1.055]; p0=[sf nu]; 
thf=-1; optn=optimset('Display','Iter','MaxIter',500);
tf=1; p=fsolve('dopcb',p0,optn,name,thf,s0,tf,N);
[f,s,th]=dopcb(p,name,thf,s0,tf,N); c=180/pi;
u=s(1,:); v=s(2,:); x=s(4,:); y=s(3,:); thh=c*[th th(N)];
%
% Spline fit to double number of points in (x,y):
ti=[0:.5/N:1]; xi=spline(t,x,ti); yi=spline(t,y,ti);
%
% Coord. of tips of thrust direction arrows:
for i=1:N, xt(i)=x(i)+.06*cos(th(i));  yt(i)=y(i)+.06*sin(th(i)); end
%
figure(1); clf; plot(x,y,'b.',xi,yi,'b'); grid; hold on 
for i=1:N, pltarrow([x(i) xt(i)],[y(i) yt(i)],.01,'r','-'); end
axis([-.02 .2 0 .22]); axis('square'); hold off; xlabel('x/at_f^2')
ylabel('y/at_f^2')
%
figure(2); clf; subplot(211), zohplot(t,thh); grid
ylabel('\theta (deg)'); subplot(212), plot(t,u,t,v,'r--'); grid
xlabel('t/t_f'); legend('u/at_f','v/at_f',2)
 
 



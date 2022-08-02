% Script p3_2_06.m; DTDP for max uf with (vf,yf) specified using DOPC;
% (also Ex. 3.2.1);                                       4/97, 6/24/02
%
global vf yf; vf=0; yf=.2;
N=20; th0=(pi/3)*[1:-2/N:-1+2/N]; s0=[0 0 0 0]'; tf=1; k=-7; tol=5e-5;
mxit=50; t=[0:1/N:1]; [th,s,nu,la0]=dopc('dtdpc',th0,s0,tf,k,tol,mxit);
u=s(1,:); v=s(2,:); y=s(3,:); x=s(4,:); thh=[th th(N)]; 
%
% Spline fit to double number of points in (x,y):
ti=[0:.5/N:1]; xi=spline(t,x,ti); yi=spline(t,y,ti);
%
% Coord. of tips of thrust direction arrows:
for i=1:N, xt(i)=x(i)+.06*cos(th(i)); yt(i)=y(i)+.06*sin(th(i)); end
%
figure(1); clf; plot(x,y,'b',x,y,'b.'); grid; hold on 
for i=1:N, pltarrow([x(i) xt(i)],[y(i) yt(i)],.008,'r','-'); end
hold off; axis([0 .35 0 .22]); xlabel('x/at_f^2'); ylabel('y/at_f^2')
%
figure(2); clf; subplot(211), zohplot(t,thh*180/pi); grid
text(.55,20,'\theta (deg)'); subplot(212), plot(t,u,t,v,'r--'); grid 
xlabel('t/t_f'); legend('u/at_f','v/at_f',2)


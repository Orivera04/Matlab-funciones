% Script e03_2_1.m; DTDP for max uf with vf=0 and yf spec. using  DOPC;
%                                                        10/96, 6/24/02
%
global vf yf; vf=0; yf=.2;
N=10; th0=(pi/3)*[1:-2/N:-1+2/N]; s0=[0 0 0 0]'; tf=1; k=-7; tol=5e-5;
[th,s,nu,la0]=dopc('dtdpc',th0,s0,tf,k,tol,10); t=[0:1/N:1];
u=s(1,:); v=s(2,:); x=s(4,:); y=s(3,:); thh=[th th(10)]; 
%
% Spline fit to double number of points in (x,y):
ti=[0:.5/N:1]; xi=spline(t,x,ti); yi=spline(t,y,ti);
%
% Coord. of tips of thrust direction arrows:
for i=1:N, xt(i)=x(i)+.06*cos(th(i));  yt(i)=y(i)+.06*sin(th(i)); end
%
figure(1); clf; plot(x,y,'b.',xi,yi,'b'); grid; hold on; 
for i=1:N, pltarrow([x(i) xt(i)],[y(i) yt(i)],.012,'r','-'); end
hold off; axis([0 .35 0 .22]); xlabel('x/at_f^2'); ylabel('y/at_f^2')
%
figure(2); clf; subplot(211), zohplot(t,thh*180/pi); grid
ylabel('Theta (deg)'); subplot(212), plot(t,u,t,v,'r--'); grid
xlabel('t/t_f'); legend('u/at_f','v/at_f',2);


% Script e03_5_2.m; DTDP for max uf to vf=0 and spec. yf using DOPCF;
%                                                         3/97, 6/24/02
%
global vf yf; vf=0; yf=.2;
N=10; s0=[0 0 0 0]'; tf=1; t=tf*[0:N]/N; th0=1.0472; name='dtdpc'; 
la0=[1 2.3960 4.7923 0]; nu=[-2.3963 4.7923]; p0=[la0 nu];
optn=optimset('Display','Iter','MaxIter',50);
p=fsolve('dopcf',p0,optn,name,th0,s0,tf,N);
[f,s,th]=dopcf(p,name,th0,s0,tf,N); thh=[th th(N)]; u=s(1,:); v=s(2,:);
y=s(3,:); x=s(4,:);   
%
% Spline fit to double number of points in (x,y):
ti=[0:.5/N:1]; xi=spline(t,x,ti); yi=spline(t,y,ti);
%
% Coord. of tips of thrust direc. arrows:
for i=1:N, xt(i)=x(i)+.06*cos(th(i)); yt(i)=y(i)+.06*sin(th(i)); end
%
figure(1); clf; plot(x,y,'b.',xi,yi,'b'); grid; hold on 
for i=1:N,  pltarrow([x(i) xt(i)],[y(i) yt(i)],.01,'r','-'); end
hold off; axis([0 .35 0 .22]); xlabel('x/at_f^2'); ylabel('y/at_f^2')
%
figure(2); clf; subplot(211), zohplot(t,thh*180/pi);
grid; ylabel('\theta (deg)'); subplot(212), plot(t,u,t,v,'r--'); grid
xlabel('t/t_f'); legend('u/at_f',' v/at_f',2);



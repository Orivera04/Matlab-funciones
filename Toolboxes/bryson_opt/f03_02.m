% Script f03_02.m; DTDP for max uf (no gravity) with spec. 
% (yf,vf) using analytical soln; th0 found by interpolation 
% to give yf=.2;                              11/96, 4/1/02
%
N=10; th0=65.13*pi/180; t=[0:1/N:1]; dt=1/N; N1=N+1;
u(1)=0; v(1)=0; y(1)=0; x(1)=0;
for i=1:N,  th(i)=atan(tan(th0)*(1-2*(i-1)/(N-1)));
 u(i+1)=u(i)+dt*cos(th(i)); v(i+1)=v(i)+dt*sin(th(i));
 y(i+1)=y(i)+dt*v(i)+(dt^2/2)*sin(th(i));
 x(i+1)=x(i)+dt*u(i)+(dt^2/2)*cos(th(i)); end
%
% Spline fit to increase number of points in (x,y):
ti=[0:.1/N:1]; xi=spline(t,x,ti); yi=spline(t,y,ti);
%
% Coordinates of tips of thrust direction arrows:
for i=1:N, xt(i)=x(i)+.06*cos(th(i)); yt(i)=y(i)+.06*sin(th(i)); 
end
%
figure(1); clf; plot(x,y,'b.',xi,yi,x(N1),y(N1),'ro'); grid
hold on; for i=1:N, 
    pltarrow([x(i) xt(i)],[y(i) yt(i)],.01,'r','-');
end; hold off; axis([0 .35 0 .22]); xlabel('x/at_f^2')
ylabel('y/at_f^2')
%
uh=[th th(10)]; 
figure(2); clf; subplot(211), zohplot(t,uh*180/pi); grid
ylabel('\theta (deg)'); subplot(212), plot(t,u,t,v,'r--'); grid
xlabel('t/t_f'); legend('u/at_f','v/at_f',2);
   
   
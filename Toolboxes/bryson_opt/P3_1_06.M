% Script p3_1_06.m; DTDP for max uf with spec. (yf,vf); th0
% found off-line by interpolation to give yf=.2; 2/97, 3/30/02
%
N=10; th0=65.13*pi/180; dt=1/N; t=[0:dt:1];
u(1)=0; v(1)=0; y(1)=0; x(1)=0;
for i=1:N,
 th(i)=atan(tan(th0)*(1-2*(i-1)/(N-1))); co=cos(th(i)); 
 si=sin(th(i));  u(i+1)=u(i)+dt*co; v(i+1)=v(i)+dt*si;
 y(i+1)=y(i)+dt*v(i)+(dt^2/2)*si; 
 x(i+1)=x(i)+dt*u(i)+(dt^2/2)*co;
end; uh=[th th(N)]; 
%
% Spline fit to double number of points in (x,y):
ti=[0:.05:1]; xi=spline(t,x,ti); yi=spline(t,y,ti);
%
% Coord. of tips of thrust direction arrows:
for i=1:N, xt(i)=x(i)+.06*cos(th(i)); yt(i)=y(i)+.06*sin(th(i));
end
%
figure(1); clf; plot(x,y,'b.',xi,yi,'b'); grid; hold on 
for i=1:N, pltarrow([x(i) xt(i)],[y(i) yt(i)],.01,'r','-'); end
hold off; axis([0 .35 0 .22]); xlabel('x/at_f^2') 
ylabel('y/at_f^2')
%
figure(2); clf; subplot(211), zohplot(t,uh*180/pi); grid
text(.55,20,'\theta (deg)'); subplot(212), plot(t,u,t,v,'r--');
grid; xlabel('t/t_f'); legend('u/at_f','v/at_f',2)
	

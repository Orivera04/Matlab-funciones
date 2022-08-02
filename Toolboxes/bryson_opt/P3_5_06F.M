% Script p3_5_06f.m; DTDP for max uf with (vf,yf) & specified using 
% DOPCF;                                              3/97, 5/27/02
%
N=10; la0=[1 2.396 4.792 0]; nu=[-2.396 4.792]; s0=[0 0 0 0]'; 
tf=1; t=[0:N]/N; name='dtdpc'; 
optn=optimset('Display','Iter','MaxIter',500); p0=[la0 nu];
th0=1.14; p=fsolve('dopcf',p0,optn,name,th0,s0,tf,N);
[f,s,th]=dopcf(p,name,th0,s0,tf,N); c=180/pi; thh=c*[th th(N)];
u=s(1,:); v=s(2,:); y=s(3,:); x=s(4,:); 
%
% Spline fit to double number of points in (x,y):
ti=[0:.5/N:1]; xi=spline(t,x,ti); yi=spline(t,y,ti);
%
% Coord. of tips of thrust direction arrows:
for i=1:N,
    xt(i)=x(i)+.06*cos(th(i)); yt(i)=y(i)+.06*sin(th(i)); end
%
figure(1); clf; plot(x,y,'b.',xi,yi,'b'); grid; hold on 
for i=1:N, pltarrow([x(i) xt(i)],[y(i) yt(i)],.01,'r','-'); end
hold off; axis([0 .35 0 .22]); xlabel('x/at_f^2') 
ylabel('y/at_f^2')
%
figure(2); clf; subplot(211), zohplot(t,thh); grid 
text(.55,20,'\theta (deg)'); subplot(212), plot(t,u,t,v,'r--');
grid; xlabel('t/t_f'); legend('u/at_f','v/at_f',2)




% Script p3_5_09f.m; DTDP for max uf with gravity and (vf,yf) spec. 
% using DOPCF; s=[u,v,y,x]'; t in tf, (u,v) in a*tf, (x,y) in 
% a*tf^2, g in a;                                      3/97, 5/27/02
%
N=50; s0=[0 0 0 0]'; tf=1; la0=[1 5.866 8.737 0]; nu=[-2.871 8.737];
p0=[la0 nu]; t=[0:N]/N; name='dtdpgc'; th0=1.39;
optn=optimset('Display','Iter','MaxIter',500);
p=fsolve('dopcf',p0,optn,name,th0,s0,tf,N); c=180/pi;
[f,s,th]=dopcf(p,name,th0,s0,tf,N); u=s(1,:); v=s(2,:);
x=s(4,:); y=s(3,:); uh=c*[th th(N)];
%
% Spline fit to double number of points in (x,y):
ti=tf*[0:.5/N:1]; xi=spline(t,x,ti); yi=spline(t,y,ti);
%
% Coord. of tips of thrust direction arrows:
for i=1:N, xt(i)=x(i)+.06*cos(th(i)); yt(i)=y(i)+.06*sin(th(i));
end
%
figure(1); clf; plot(x,y,'b.',xi,yi,'b'); grid; hold on 
for i=1:N, pltarrow([x(i) xt(i)],[y(i) yt(i)],.01,'r','-'); end
hold off; axis([-.04 .24 0 .21]); xlabel('x/at_f^2')
ylabel('y/at_f^2')
%
figure(2); clf; subplot(211), zohplot(t,uh); grid 
ylabel('\theta (deg)'); subplot(212), plot(t,u,t,v,'r--'); 
grid; xlabel('t/t_f'); legend('u/at_f','v/at_f',2)

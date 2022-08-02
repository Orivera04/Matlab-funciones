% Script p3_5_10n.m; DTDP for max uf with gravity and (vf,yf,xf) speci-
% fied using DOPCN; s=[u,v,y,x]'; t in tf, (u,v) in a*tf, (x,y) in a*tf^2,
% g in a; 				                                     3/97, 5/27/02
%
N=10; s0=[0 0 0 0]'; tf=1; t=[0:N]/N; name='dtdpgcx'; 
optn=optimset('Display','Iter','MaxIter',500);
th=[1.572 1.528 1.462  1.354 1.152 .717 -.037 -.603 -.866 -1.000]; 
nu=[-1.715 4.831 -1.055]; p0=[th nu];
p=fsolve('dopcn',p0,optn,name,s0,tf);
[f,s,la0]=dopcn(p,name,s0,tf); th=p([1:N]); c=180/pi;
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


% Script p3_2_09.m; DTDP for max uf with gravity and (vf,yf) 
% specified using DOPC; s=[u,v,y,x]'; t in tf, (u,v) in a*tf, 
% (x,y) in a*tf^2, g in a;                     4//97, 3/31/02
%
N=10; th0=(pi/3)*[1:-2/N:-1+2/N]; x0=[0 0 0 0]'; tf=1; k=-2;
tol=5e-5; mxit=100; t=[0:N]/N;
[th,s,nu,la0]=dopc('dtdpgc',th0,x0,tf,k,tol,mxit);
u=s(1,:); v=s(2,:); x=s(4,:); y=s(3,:); thh=[th th(N)]; 
%
% Spline fit to double number of points in (x,y):
ti=[0:.5/N:1]; xi=spline(t,x,ti); yi=spline(t,y,ti);
ui=spline(t,u,ti); vi=spline(t,v,ti);
%
% Coord. of tips of thrust direction arrows:
for i=1:N, xt(i)=x(i)+.06*cos(th(i)); 
    yt(i)=y(i)+.06*sin(th(i)); end
%
figure(1); clf; plot(x,y,'.b',xi,yi,'b'); grid; hold on; 
for i=1:N, pltarrow([x(i) xt(i)],[y(i) yt(i)],.008,'r','-');
end; hold off; axis([-.04 .24 0 .21]); xlabel('x/at_f^2'); 
ylabel('y/at_f^2');
%
figure(2); clf; subplot(211), zohplot(t,thh*180/pi); grid; 
ylabel('Theta (deg)'); subplot(212), plot(ti,ui,ti,vi,'r--'); 
grid; xlabel('t/t_f'); legend('u/at_f','v/at_f',2);


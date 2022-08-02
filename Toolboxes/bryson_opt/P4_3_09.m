% Script p4_3_09.m; DTDP for min tf w. gravity to vf=0 & spec.
% (uf,yf);                                           4/97, 3/31/02
%
clear; clear global; global yf g; yf=.2/.4935^2; g=1/3; 
th=[1:-2/9:-1]; s0=[0 0 0 0]'; tf=1/.4935; k=6; tol=5e-5; mxit=100;
N=length(th); [th,s,tf,nu,la0]=dopt('dtdpgt',th,s0,tf,k,tol,mxit);
t=tf*[0:.1:1]; u=s(1,:); v=s(2,:); y=s(3,:); x=s(4,:);
thh=[th th(N)]*180/pi; 
%
% Spline fit to double number of points in (x,y):
ti=tf*[0:.5/N:1]; xi=spline(t,x,ti); yi=spline(t,y,ti);
%
% Calculate coord. of tips of thrust direction arrows:
for i=1:N, xt(i)=x(i)+.15*cos(th(i)); yt(i)=y(i)+.15*sin(th(i)); 
end
%
figure(1); clf; plot(x,y,'b.',xi,yi,'b'); grid; hold on; 
for i=1:N, pltarrow([x(i) xt(i)],[y(i) yt(i)],.024,'r','-'); end
hold off; axis([-.15 1.05 0 .9]); xlabel('ax/u_f^2'); 
ylabel('ay/u_f^2');
%
figure(2); clf; subplot(211), zohplot(t,thh); grid; 
axis([0 2.1 -100 100]); ylabel('Theta (deg)');
subplot(212), plot(t,u,t,v,'r--'); grid; xlabel('at/u_f');
axis([0 2.1 0 1]); legend('u/u_f','v/u_f',2);

 
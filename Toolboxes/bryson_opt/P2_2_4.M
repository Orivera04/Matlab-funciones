% Script p2_2_4.m; DVDP for max range w. V=1+y using DOP0 (Fermat
% Pb.);                                       4/97, 1/98, 3/23/02 
%
N=40; u=(pi/6)*ones(1,N); s0=[0 0]'; tol=1e-4; mxit=100; N1=N+1;
figure(1); clf; figure(2); clf; tf1=[.5 1 1.5 2]; k1=-[5 4 3 2];
for i=1:4, tf=tf1(i); k=k1(i);
   [u,s]=dop0('dferm1',u,s0,tf,k,tol,mxit); x=s(1,:); y=s(2,:);
   t=tf*[0:1/N:1]; uh=[u u(N)]*180/pi; figure(1); plot(x,y,x,...
   y,'.',x(N1),y(N1),'o'); hold on; figure(2); zohplot(t,uh); 
hold on; end
figure(1); grid; hold off; xlabel('x'); ylabel('y');
text(3.3,2.55,'tf=2'); text(1.2,.55,'1'); text(2.2,1.4,'1.5');
text(.6,.15,'.5'); figure(2); grid; hold off; xlabel('Time'); 
ylabel('\theta (deg)');

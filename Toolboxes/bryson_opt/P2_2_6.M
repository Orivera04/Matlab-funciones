% Script p2_2_6.m; DVDP for max xf with gravity, thrust, drag; (x,y)
% in l, V in sqrt(gl), t in sqrt (l/g);          5/97, 2/98, 3/23/02
%
global a; a=.05; N=20; u0=-.15*ones(1,N); s0=[0 0 0]'; tf=5; k=-1;
tol=1e-4; mxit=30; [ga,s,la0]=dop0('dvdp0td',u0,s0,tf,k,tol,mxit);
s=real(s); ga=real(ga); v=s(1,:); x=s(2,:); y=s(3,:); ke=v.^2/2; 
c=180/pi; gah=c*[ga ga(N)]; N1=N+1; t=tf*[0:1/N:1]; la0=real(la0);
%
% Comparison; vert. dive to opt. V, then opt. const. ga (see Pb. 2.3.6):
Vs=sqrt(2*a/3+sqrt((a/3)^2+1/3));                 % V for max steady xdot
gas=asin(sqrt((a/3)^2+1/3)-a/3);                 % ga for max steady xdot
b=sqrt(1+a); ts=atanh(Vs/b)/b; ys=log(cosh(ts*b));               
xfs=Vs*cos(gas)*(tf-ts); yfs=ys+xfs*tan(gas); kes=Vs^2/2;
%
figure(1); clf; subplot(211), plot(x,y,'b.',x,y,'b',[0 xfs],[-ys -yfs],...
   'r--',[.01 .01],[0 -ys],'r--',0,0,'ro',.01,-ys,'ro',xfs,-yfs,'ro',...
   x(N1),y(N1),'o'); grid; xlabel('x'); ylabel('-y');
subplot(212), plot(ke,y,'b.',ke,y,'b',[kes,kes],[-ys -yfs],'r--',...
   kes,-ys,'ro',kes,-yfs,'ro',[0 kes],[0 -ys],'r--',v(N1)^2/2,y(N1),...
   'o',0,0,'o'); grid; ylabel('-y'); xlabel('V^2/2');
%
figure(2); clf; zohplot(t,gah); grid; hold on; ylabel('\gamma (deg)'); 
plot([0 tf],[-gas -gas]*c,'r--'); hold off; xlabel('Time'); 




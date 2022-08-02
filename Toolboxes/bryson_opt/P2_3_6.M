% Script p2_3_6.m; VDP with gravity, thrust, and drag; s=[V ga x y]',
% t in sqrt(l/g), V in sqrt(gl), (x,y) in l, a in g; finds `k' to make
% ga(tf)=0;                                              2/95, 6/27/02
%
a=.05; tf=5; t0=.05; optn=optimset('Display','Iter','MaxIter',10);
k0=1.62; V0=(1+a)*t0; k=fsolve('vdpgtd_o',k0,optn,a,tf,t0);
y0=-V0*t0/2; ga0=-pi/2+k*V0; s0=[V0 ga0 0 y0]'; 
opt1=odeset('reltol',1e-4); [t,s]=ode23('vdpgtd',[t0 tf],s0,opt1,a);
N=length(t); s=real(s); V=s(:,1); ga=s(:,2); x=s(:,3); y=s(:,4);
ke=V.^2/2; c=180/pi; 
%
% Comparison; vert. dive to V(ts)=Vs, y(ts)=ys, then ga=gas:
Vs=sqrt(2*a/3+sqrt((a/3)^2+1/3));              % V for max steady xdot
gas=-asin(sqrt((a/3)^2+1/3)-a/3);             % ga for max steady xdot
b=sqrt(1+a); ts=atanh(Vs/b)/b; ys=-log(cosh(ts*b));               
xfs=Vs*cos(gas)*(tf-ts); yfs=ys+xfs*tan(gas); kes=Vs^2/2;
%
figure(1); clf; subplot(211), plot(x,y,'.',x,y,[0 xfs],[ys yfs],...
  'r--',[.01 .01],[0 ys],'--',0,0,'o',.01,ys,'ro',xfs,yfs,'ro',...
  x(N),y(N),'bo'); grid; xlabel('x/l'); ylabel('y/l')
subplot(212), plot(ke,y,'.',ke,y,[kes,kes],[ys yfs],'r--',kes,ys,...
  'ro',kes,yfs,'ro',[0 kes],[0 ys],'r--',V(N)^2/2,y(N),'bo',0,0,'o');
grid; ylabel('y/l'); xlabel('V^2/2gl')
%
figure(2); clf; plot(t,c*ga,t,c*ga,'.',[0 tf],c*[gas gas],'r--',...
   [0 t0],[-90 ga0*c],tf,0,'o'); grid; xlabel('Time')
ylabel('\gamma (deg)') 
%
figure(3); clf; plot(V,2*ga/pi,V,2*ga/pi,'.',0,-1,'o',Vs,...
   2*gas/pi,'o'); grid; xlabel('V'); ylabel('2\gamma/ \pi')
axis([0 .8 -1 0]) 
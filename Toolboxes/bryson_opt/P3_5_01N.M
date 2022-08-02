% Script p3_5_01n.m; DVDP for max range with gravity & spec. yf using
% DOPCN;                                          4/97, 1/98, 6/22/98
%
N=50; u0=(pi/2)*[1:-1/N:1/N]; s0=[0 0 0]'; tf=1; name='dvdpc'; 
nu=-.4871; p0=[u0 nu]; optn=optimset('Display','Iter','MaxIter',50);
N1=N+1; p=fsolve('dopcn',p0,optn,name,s0,tf);
[f,s,la0]=dopcn(p,name,s0,tf); t=[0:N]/N; u=p([1:N]); uh=[u u(N)];
x=s(2,:); y=s(3,:); 
%
figure(1); clf; plot(x,-y,x,-y,'.',x(N1),-y(N1),'ro'); grid;
axis([0 .36 -.27 0]); ylabel('-y/gt_f^2'); xlabel('x/gt_f^2');
%
figure(2); clf; zohplot(t,2*uh/pi); grid; xlabel('t');
ylabel('2 \gamma / \pi');
	
	
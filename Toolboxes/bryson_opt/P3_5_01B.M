% Script p3_5_01b.m; DVDP for max range with gravity & spec. yf using
% DOPCB;                                                4/97, 5/27/02
%
N=50; sf=[.4472 .2924 .1]; s0=[0 0 0]'; tf=1; name='dvdpc'; nu=-.4871;
p0=[sf nu]; uf=-.25; optn=optimset('Display','Iter','MaxIter',500); 
p=fsolve('dopcb',p0,optn,name,uf,s0,tf,N);
[f,s,u,la]=dopcb(p,name,uf,s0,tf,N); N1=N+1; x=s(2,:); y=s(3,:);
t=[0:N]/N; uh=[u u(N)]; 
%
figure(1); clf; plot(x,-y,x,-y,'.',x(N1),-y(N1),'ro'); grid
axis([0 .36 -.27 0]); ylabel('-y/gt_f^2'); xlabel('x/gt_f^2')
%
figure(2); clf; zohplot(t,2*uh/pi); grid; xlabel('t')
ylabel('2 \gamma/ \pi');
	
	
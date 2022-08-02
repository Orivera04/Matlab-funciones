% Script p4_2_01.m; DVDP for min time to a point w. gravity 
% using FSOLVE;                                 12/96, 3/27/02
%
N=5; ga=(pi/2)*[1:-1/N:1/N]; nu=[0 0]; dt=2/N; p=[ga nu dt]; 
optn=optimset('Display','Iter','MaxIter',50); N1=N+1;
p=fsolve('dvdpt_f',p,optn); [f,v,x,y]=dvdpt_f(p); ga=p([1:N]);
gah=[ga ga(N)]; dt=p(N+3); t=dt*[0:N]; nux=p(N+1); nuy=p(N+2); 
%
figure(1); clf; plot(x,-y,x,-y,'b.',x(N1),-y(N1),'ro'); grid
xlabel('x/x_f'); ylabel('y/x_f'); axis([0 1 -.75 0])
%
figure(2); clf; zohplot(t,2*gah/pi); grid; axis([0 2 -.2 1])
xlabel('t*sqrt(g/x_f)'); ylabel('2 \gamma/ \pi')
	
	
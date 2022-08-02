% Script p3_1_01.m; DVDP for max range with gravity and
% specified yf using FSOLVE;              12/96, 3/30/02
%
N=5; u=(pi/2)*[1:-1/N:1/N]; nu=0;      % Estim of u & nu
p=[u nu]; optn=optimset('Display','Iter','MaxIter',200); 
p=fsolve('dvdpc_f',p,optn); [f,v,x,y]=dvdpc_f(p); 
t=[0:1/N:1]; u=p([1:5]); uh=[u u(N)];
%
figure(1); clf; plot(x,-y,x,-y,'.',x(6),-y(6),'o');
grid; xlabel('x'); ylabel('y'); axis([0 .36 -.27 0]);
%
figure(2); clf; zohplot(t,2*uh/pi); grid
axis([0 1 -.2 1]); xlabel('t');
ylabel('2 \gamma / \pi')
	
	
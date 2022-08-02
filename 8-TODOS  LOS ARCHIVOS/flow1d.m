%  This a model for the concentration of a pollutant.
%  Assume the stream has constant velocity.
clear;
L = 1.0;    %  length of the stream
T = 20.;    %  duration of time
K = 200;    %  number of time steps
dt = T/K;
n = 10.;    %  number of space steps
dx = L/n;
vel =.1;   %  velocity of the stream
decay = .1; % decay rate of the pollutant
for i = 1:n+1   %  initial concentration
	x(i) =(i-1)*dx;
	u(i,1) =(i<=(n/2+1))*sin(pi*x(i)*2)+(i>(n/2+1))*0;
end
for k=1:K+1 %  upstream concentration
	time(k) = (k-1)*dt;
	u(1,k) = .2;
end
%
% Execute the finite difference algorithm.
%
for k=1:K   %  time loop
	for i=2:n+1 %  space loop
		u(i,k+1) =(1 - vel*dt/dx -decay*dt)*u(i,k) + vel*dt/dx*u(i-1,k);
	end
end
mesh(x,time,u')
% contour(x,time,u')
% plot(x,u(:,1),x,u(:,51),x,u(:,101),x,u(:,151))
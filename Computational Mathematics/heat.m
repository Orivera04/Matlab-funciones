%  This code models heat diffusion in a thin wire.
%  It executes the explicit finite difference method.
clear;
L = 1.0;    %  length of the wire
T = 600.;   %  final time
maxk = 120;     %  number of time steps
dt = T/maxk;
n = 10.;    %  number of space steps
dx = L/n;
b = dt/(dx*dx);
cond = .001;    % thermal conductivity
spheat = 1.0;   % specific heat
rho = 1.;   % density
a = cond/(spheat*rho);
alpha = a*b;
f = 1.;     %   internal heat source
for i = 1:n+1   %  initial temperature
	x(i) =(i-1)*dx;
	u(i,1) =sin(pi*x(i));
end
for k=1:maxk+1  %  boundary temperature
	u(1,k) = 0.;
	u(n+1,k) = 0.;
	time(k) = (k-1)*dt;
end
%
% Execute the explicit method using nested loops.
%
for k=1:maxk    %  time loop
   for i=2:n;   %  space loop  
		u(i,k+1) =f*dt/(spheat*rho)+(1-2*alpha)*u(i,k) + alpha*(u(i-1,k)+u(i+1,k));
	end
end
mesh(x,time,u')
xlabel('x')
ylabel('time')
zlabel('temperature')
%  This code models heat diffusion in a thin wire.
%  It executes the explicit finite difference method.
clear;
%
% Input data
%
L = 1.0;         %  length of the wire
T = 300.;        %  final time
maxk = 3200;     %  number of time steps
dt = T/maxk;
n = 20;          %  number of space steps
dx = L/n;
b = dt/(dx*dx);
cond = .001;     %  thermal conductivity
spheat = 1.0;    %  specific heat
rho = 1.;        %  density
a = cond/(spheat*rho);
alpha = a*b;
f = 1.;          %  internal heat source
dtc = dt/(spheat*rho);
csur = .003;    %  insulation coefficient
usur = -10;      %  surrounding temperature
r = .05;         %  radius of the wire
for i = 1:n+1    %  initial temperature
	x(i) =(i-1)*dx;
	u(i,1) = sin(pi*x(i));
end
for k = 1:maxk+1   %  boundary temperature
	u(1,k) = 0.;
	u(n+1,k) = 0.;
	time(k) = (k-1)*dt;
end
%
% Execute the explicit method using nested loops
%
for k = 1:maxk    %  time loop
   for i = 2:n;   %  space loop  
		u(i,k+1) = (f + csur*(2./r)*usur)*dtc + ... 
                    (1 - 2*alpha - dtc*csur*(2./r))*u(i,k) + ...
                     alpha*(u(i-1,k)+u(i+1,k));
   end
end
%
% Output in graphical form
%
mesh(x,time,u')
xlabel('x')
ylabel('time')
zlabel('temperature')
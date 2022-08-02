%  This is pollutant flow across a lake.
%  The explicit finite difference method is used.
clear;
L = 1.0;    % length in x direction
W = 4.0;    % length in y direction
T = 10.;    % final time
maxk = 200;    % number of time steps
dt = T/maxk;
nx = 10.;    % number of steps in x direction
dx = L/nx;
ny = 20.;    % number of steps in y direction
dy = W/ny;
velx = .1;  % wind speed in x direction
vely = .8;  % wind speed in y direction
decay = .1;     %decay rate
% Set initial conditions.
for i = 1:nx+1
   x(i) =(i-1)*dx;
   for j = 1:ny+1
      y(j) =(j-1)*dy;
      u(i,j,1) = 0.;
   end
end
% Set upwind boundary conditions.
for k=1:maxk+1
   time(k) = (k-1)*dt;
   for j=1:ny+1
      u(1,j,k) = .0;
   end
   for i=1:nx+1
      u(i,1,k) = (i<=(nx/2+1))*(k<26)*5.0*sin(pi*x(i)*2)+(i>(nx/2+1))*.1;
   end
end
%
% Execute the explicit finite difference method.
%
for k=1:maxk
   for i=2:nx+1;
      for j=2:ny+1;
         u(i,j,k+1) =(1 - velx*dt/dx -vely*dt/dy-decay*dt)*u(i,j,k)+ velx*dt/dx*u(i-1,j,k)+vely*dt/dy*u(i,j-1,k);
      end
   end
   mesh(x,y,u(:,:,k)')
   pause
end
mesh(x,y,u(:,:,maxk)')

% contour(x,y,u(:,:,maxk)')
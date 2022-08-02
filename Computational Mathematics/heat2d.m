%  This is heat diffusion in 2D space.
%  The explicit finite difference method is used.
clear;
L = 1.0;    % length in the x-direction
W = L;  % length in the y-direction
Tend = 80.;     % final time
maxk = 300;
dt = Tend/maxk;
n = 20.;
% initial condition and part of boundary condition
u(1:n+1,1:n+1,1:maxk+1) = 70.;  
dx = L/n;
dy = W/n;   % use dx = dy = h
h = dx;
b = dt/(h*h);
cond = .002;    % thermal conductivity
spheat = 1.0;   % specific heat
rho = 1.;   % density
a = cond/(spheat*rho);
alpha = a*b;
for i = 1:n+1
   x(i) =(i-1)*h;   % use dx = dy = h
   y(i) =(i-1)*h;
end
% boundary condition
for k=1:maxk+1
   time(k) = (k-1)*dt;
   for j=1:n+1
      u(1,j,k) =300.*(k<120)+ 70.;
   end
end
%
%   finite difference method computation
%
for k=1:maxk
   for j = 2:n
      for i = 2:n
         u(i,j,k+1) =0.*dt/(spheat*rho)+(1-4*alpha)*u(i,j,k) + alpha*(u(i-1,j,k)+u(i+1,j,k)+u(i,j-1,k)+u(i,j+1,k));
      end
   end
end
% temperature versus space at the final time
mesh(x,y,u(:,:,maxk)')
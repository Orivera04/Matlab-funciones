%  Heat Diffusion in a Thin Insulated Wire
clear;
%  Lenth of the Wire
L = 1.0;
%  Final Time
T =1;
%  Number of Time Steps
maxk = 3200;
dt = T/maxk;
%  Number of Space Steps
n = 40.;
dx = L/n;
b = dt/(dx*dx);
cond = 1/(pi*pi);
spheat = 1.0;
rho = 1.;
a = cond/(spheat*rho);
d = a*b;
%  Initial Temperature
for i = 1:n+1
        x(i) =(i-1)*dx;
        u(i,1) =sin(pi*x(i));
end
%  Boundary Temperature
for k=1:maxk+1
        u(1,k) = 0.;
        u(n+1,k) = 0.;
        time(k) = (k-1)*dt;
end
%  Time Loop
for k=1:maxk
%  Space Loop  
   for i=2:n;
      u(i,k+1) =0.*dt/(spheat*rho)+(1-2*d)*u(i,k) + d*(u(i-1,k)+u(i+1,k));
      error(i,k+1)= abs(u(i,k+1)-exp(-time(k))*sin(pi*x(i)));
   end
end
mesh(x,time,u')
max(error(:,maxk))
%  Heat 3D Diffusion.
%  Uses the explicit method.
%  Given boundary conditions on all sides.
clear;
L = 2.0;
W = 1.0;
T = 1.0;
Tend = 100.;
maxk = 200;
dt = Tend/maxk;
nx = 10.;
ny = 10;
nz = 10;
u(1:nx+1,1:ny+1,1:nz+1,1:maxk+1) = 70.; % Initial temperature.
dx = L/nx;
dy = W/ny;
dz = T/nz;
rdx2 = 1./(dx*dx);
rdy2 = 1./(dy*dy);
rdz2 = 1./(dz*dz);
cond = .001;
spheat = 1.0;
rho = 1.;
a = cond/(spheat*rho);
alpha = dt*a*2*(rdx2+rdy2+rdz2);
x = dx*(0:nx);
y = dy*(0:ny);
z = dz*(0:nz);
for k=1:maxk+1  %  Hot side of fin.
   time(k) = (k-1)*dt;
   for l=1:nz+1
        for i=1:nx+1
            u(i,1,l,k) =300.*(time(k)<50)+ 70.;
        end
    end
end
for k=1:maxk    %  Explicit method.
    for l=2:nz
        for j = 2:ny
            for i = 2:nx
                u(i,j,l,k+1) =(1-alpha)*u(i,j,l,k) ...
                               +dt*a*(rdx2*(u(i-1,j,l,k)+u(i+1,j,l,k))...
                                     +rdy2*(u(i,j-1,l,k)+u(i,j+1,l,k))...
                                     +rdz2*(u(i,j,l-1,k)+u(i,j,l+1,k)));
            end
        end
    end
    v=u(:,:,:,k);
    time(k)
    slice(x,y,z,v,.75,[.4 .9],.1)
    colorbar
    pause
end

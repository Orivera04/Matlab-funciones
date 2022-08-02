%  Flow with Fick Dispersion in 3D
%  Uses the explicit method.
%  Given boundary conditions on all sides.
clear;
L = 4.0;
W = 1.0;
T = 1.0;
Tend = 20.;
maxk = 100;
dt = Tend/maxk;
nx = 10.;
ny = 10;
nz = 10;
u(1:nx+1,1:ny+1,1:nz+1,1:maxk+1) = 0.;
dx = L/nx;
dy = W/ny;
dz = T/nz;
rdx2 = 1./(dx*dx);
rdy2 = 1./(dy*dy);
rdz2 = 1./(dz*dz);
disp = .001;
vel = [ .05 .1 .05];    %  Velocity of fluid.
dec = .001;     %  Decay rate of pollutant.
alpha = dt*disp*2*(rdx2+rdy2+rdz2);
x = dx*(0:nx);
y = dy*(0:ny);
z = dz*(0:nz);
for k=1:maxk+1  %  Source of pollutant.
   time(k) = (k-1)*dt;
   for l=1:nz+1
        for i=1:nx+1
            u(i,1,2,k) =10.*(time(k)<15);
        end
    end
end
coeff =1-alpha-vel(1)*dt/dx-vel(2)*dt/dy-vel(3)*dt/dz-dt*dec
for k=1:maxk    %  Explicit method.
    for l=2:nz
        for j = 2:ny
            for i = 2:nx
                u(i,j,l,k+1)=coeff*u(i,j,l,k) ...
                             +dt*disp*(rdx2*(u(i-1,j,l,k)+u(i+1,j,l,k))...
                                      +rdy2*(u(i,j-1,l,k)+u(i,j+1,l,k))...
                                      +rdz2*(u(i,j,l-1,k)+u(i,j,l+1,k)))...
                                      +vel(1)*dt/dx*u(i-1,j,l,k)...
                                      +vel(2)*dt/dy*u(i,j-1,l,k)...
                                      +vel(3)*dt/dz*u(i,j,l-1,k);
            end
        end
    end
    v=u(:,:,:,k);
    time(k)
    slice(x,y,z,v,3.9,[.2 .9],.1 )
    colorbar
    pause
end

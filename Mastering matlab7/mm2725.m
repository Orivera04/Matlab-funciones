[X,Y,Z] = peaks(20);
[Nx,Ny,Nz] = surfnorm(X,Y,Z);
surf(X,Y,Z)
hold on
quiver3(X,Y,Z,Nx,Ny,Nz)
hold off
axis tight
title('Figure 27.25: 3-D Quiver Plot')
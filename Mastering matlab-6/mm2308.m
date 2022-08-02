[x,y,z] = peaks; % default output of peaks
dx = x(1,2) - x(1,1); % spacing in x direction
dy = y(2,1) - y(1,1); % spacing in y direction
L = del2(z,dx,dy);
surf(x,y,z,abs(L))
shading interp
title('Figure 23.8: Discrete Laplacian Color')
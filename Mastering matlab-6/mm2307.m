[x,y,z] = peaks(20); % simple 2-D function
dx = x(1,2) - x(1,1); % spacing in x direction
dy = y(2,1) - y(1,1); % spacing in y direction
[dzdx,dzdy] = gradient(z,dx,dy);
contour(x,y,z)
hold on
quiver(x,y,dzdx,dzdy)
hold off
title('Figure 23.7: Gradient Arrow Plot')
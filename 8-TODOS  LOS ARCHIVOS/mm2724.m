[X,Y,Z] = peaks(16);
[DX,DY] = gradient(Z,.5,.5);
contour(X,Y,Z,10)
hold on
quiver(X,Y,DX,DY)
hold off
title('Figure 27.24: 2-D Quiver Plot')
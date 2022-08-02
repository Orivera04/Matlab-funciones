close
[X,Y,Z] = peaks;
C = contour(X,Y,Z,12);
clabel(C)
title('Figure 27.22: Contour Plot With Labels')
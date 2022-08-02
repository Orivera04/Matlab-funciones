[X,Y,Z] = peaks;
C = contour(X,Y,Z,12);
clabel(C)
title('Figure 26.24: Contour Plot With Labels')
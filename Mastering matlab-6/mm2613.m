[X,Y,Z] = peaks(30);
surfc(X,Y,Z)  % surf plot with contour plot
xlabel('X-axis'), ylabel('Y-axis'), zlabel('Z-axis')
title('Figure 26.13: Surface Plot with Contours')
[X,Y,Z] = peaks;

subplot(1,2,1)
pcolor(X,Y,Z)
shading interp  % remove the grid lines
axis square
title('Figure 27.21a: Pseudocolor Plot')
subplot(1,2,2)
contourf(X,Y,Z,12) % filled contour plot with 12 contours
axis square
xlabel('X-axis'), ylabel('Y-axis')
title('Figure 27.21b: Filled Contour Plot')
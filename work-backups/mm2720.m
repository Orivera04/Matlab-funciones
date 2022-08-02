[X,Y,Z] = peaks;
subplot(1,2,1)
contour(X,Y,Z,20)   % generate 20 2-D contour lines
axis square
xlabel('X-axis'), ylabel('Y-axis')
title('Figure 27.20a: 2-D Contour Plot')
subplot(1,2,2)
contour3(X,Y,Z,20)  % the same contour plot in 3-D
xlabel('X-axis'), ylabel('Y-axis'), zlabel('Z-axis')
title('Figure 27.20b: 3-D Contour Plot')
[X,Y,Z] = peaks(30);
surf(X,Y,Z)  % same plot as above
xlabel('X-axis'), ylabel('Y-axis'), zlabel('Z-axis')
shading interp
title('Figure 26.11: Surface Plot with Interpolated Shading')
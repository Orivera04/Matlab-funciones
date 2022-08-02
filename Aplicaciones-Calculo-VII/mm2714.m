[X,Y,Z] = peaks(30);
surfl(X,Y,Z)    % surf plot with lighting
shading interp  % surfl plots look best with interp shading
colormap pink   % they also look better with shades of a single color
xlabel('X-axis'), ylabel('Y-axis'), zlabel('Z-axis')
title('Figure 27.14: Surface Plot with Lighting')
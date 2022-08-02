% EX10_1.M Plot a contour map and surface of the function
%  z=x^2y+x^2+2y^2
clear                   % Clear variable and figures
clf 
x=[-2.0:.15:2.0];       % Define x,y points
y=[-2.0:0.15:2.0];
v=[0.5 1 2];		% Define level values
[X,Y]=meshgrid(x,y);    % Create matrix of points
Z=Y.*(X.^2)+X.^2+2*(Y.^2);
c=contour(x,y,Z,v);
clabel(c)               % Add height values to contours
title('Contour Plot of z=x^2y+x^2+2y^2')
pause
% Plot a surface and mesh
figure                  % Create a new figure window
subplot(2,1,1),surf(X,Y,Z)
xlabel('x')
ylabel('y')
subplot(2,1,2),plot3(X,Y,Z)
title('Surface and Mesh Plots')
xlabel('x')
ylabel('y')
%
% Strike a key to see second plot after the pause
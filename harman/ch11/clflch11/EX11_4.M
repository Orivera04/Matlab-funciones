% EX11_4.M Plot the gradient of f(x,y)=[x^(2)+y^(2)]^(1/2)
%
clear                     % Clear variables
clf                       %  and figures
[x,y]=meshgrid(-1:.1:1);  % Create a grid of points
R=sqrt(x.^(2)+y.^(2));
[dx,dy]=gradient(R,.1,.1); % Compute gradient
contour(x,y,R);            % Draw contours
axis('square')             % Force radial symmetry
hold on
quiver(x,y,dx,dy);         % Plot vectors
title('Plot of Gradient Field-f(x,y)=R')
xlabel('x')
ylabel('y')
zoom             % Change resolution with mouse

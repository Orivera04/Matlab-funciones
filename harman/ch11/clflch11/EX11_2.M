% EX11_2.M Plots field of inverse square field using
%  quiver command
clear                        % Clear variables
clf                          %  and figures
[x,y]=meshgrid(-1:.2:1);     % Define a grid
R=sqrt(x.^(2)+y.^(2)) + eps; % Avoid divide by zero
fx=-x./R.^(3);
fy=-y./R.^(3);
quiver(x,y,fx,fy);           % Plot vectors
title('Plot of Inverse-square Force Field')
xlabel('x')
ylabel('y')
zoom                 % Change resolution with mouse

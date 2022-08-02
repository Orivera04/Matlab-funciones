% EX7_2.M Spline interpolation of the function y=1/(1+x^2)
%   with a cubic polynomial
x=[-5:1:5];             % N+1=11 points
y=1./(1+x.^2);          % Runge function
% Spline function
xspline=[-5:.1:5];      % Finer spacing in x
yspline = spline(x,y,xspline);
% Plot
clf                     % Clear any figures
plot(x,y,'o',xspline,yspline,'-')
title('Spline Function Interpolation Figure 7.2')
axis([-6 6 -.5 2])
%
% Modify the script to allow spline fitting of general
% functions
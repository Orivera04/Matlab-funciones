% CLINT2D.M Create data, plot original data and then 
%  perform 2D interpolation for Example 10.9.
%
x=[0:1:4];		% Original x points
y=[0:1:4];		% Original y points
[X,Y]=meshgrid(x,y);	% Rows of X are x; columns of Y are y
Z=(X-2).^2+(Y-2).^2;	% A matrix as Z(X,Y)
%
xi=[0:.2:4];		% x points to interpolate
yi=[0:.2:4]';		% y points to interpolate
Zi=interp2(X,Y,Z,xi,yi,'cubic');
% Plot surface and contours to compare plots
clf			% Clear graphics window
subplot(2,1,1), surfc(x,y,Z)
xlabel('Original x ')
ylabel('Original y ')
title('Surface without interpolation')
subplot(2,1,2), surfc(xi,yi,Zi)
xlabel('Interpolated x ')
ylabel('Interpolated y ')
title('Surface (x-2)^2+(y-2)^2 from 2D Interpolation')
%
% Modify the script to allow input of a general function
%  and arbitrary ranges of x and y and modify the 
%  comments appropriately.
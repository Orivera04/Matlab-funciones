
function [xt, yt] = rot2d(t, x, y)

% Function rot2d rotates a two-dimensional object
% that is represented by two vectors x and y. The 
% angle of rotation t is in the degree measure. 
% Images of x and y are saved in xt and yt, respectively.

t1 = t*pi/180;
r = [cos(t1) -sin(t1);sin(t1) cos(t1)];
x = [x x(1)];
y = [y y(1)];
hold on
grid on
axis equal
fill(x, y,'b')
z = r*[x;y];
xt = z(1,:);
yt = z(2,:);
fill(xt, yt,'r');
title(sprintf('Plane rotation through the angle of %3.2f degrees'...
,t))
hold off

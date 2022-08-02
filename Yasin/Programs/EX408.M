% A program of type script
% Program name is ex408.m 
% To accompany the textbook:
% Applications of MATLAB: Numerical Solutions.
% By Yasin A. Shiboul
% To run this program, enter its name,'ex408' in the command window.

x = -5:0.1:5;
y = -4:0.1:4;
[x,y]=meshgrid(x,y);
z = (x.*y).^3;
surf(x,y,z)
xlabel('x axis')
ylabel('y axis')
zlabel('z axis')
title('Example 8 of chapter 4')
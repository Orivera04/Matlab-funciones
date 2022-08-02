% P6_7.M  Plot the solution to the equation
%  y''+y=0 with y(0)=2 and y(pi/2)=1.
%
x=[0:.01:pi/2];
y=2*cos(x) + (1-(pi/2))*sin(x) + x;
clf
plot(x,y)
title('Solution to y''+y=0 with y(0)=2, y(1.57)=1')
grid;
xlabel('x')
ylabel('y(x)')
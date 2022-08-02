x = linspace(0,3*pi);  % x-axis data
z1 = sin(x);           % plot in x-z plane
z2 = sin(2*x);
z3 = sin(3*x);
y1 = zeros(size(x));   % spread out along y-axes
y3 = ones(size(x));    % by giving each curve different y-axis values
y2 = y3/2;
plot3(x,y1,z1,x,y2,z2,x,y3,z3)
grid on
xlabel('X-axis'), ylabel('Y-axis'), zlabel('Z-axis')
title('Figure 26.2: sin(x), sin(2x), sin(3x)')
pause
plot3(x,z1,y1,x,z2,y2,x,z3,y3)
grid on
xlabel('X-axis'), ylabel('Y-axis'), zlabel('Z-axis')
title('Figure 26.3: sin(x), sin(2x), sin(3x)')
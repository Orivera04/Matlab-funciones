% Plot a 2 by 2 system as straight lines
x = -2:5;
y1 = -0.5 * x + 1;
y2 = -x + 3;
plot(x,y1,x,y2)
axis([-2 5 -4 6])
xlabel('x')
ylabel('y')
title('Visualize 2x2 system')

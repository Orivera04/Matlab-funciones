hold on
x = 0:pi/40:3*pi;
y = sin(x);
y = y .* (y > 0);
axis([0 10 0 2])
plot(x, y)
hold off
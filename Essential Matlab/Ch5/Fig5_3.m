clf
hold on
subplot(2,2,1)
x = -3/2*pi:pi/100:3/2*pi;
y = tan(x);
plot(x,y),title('(a)')
y = y .* (abs(y) < 1e10);
subplot(2,2,2)
plot(x,y),title('(b)')
hold off
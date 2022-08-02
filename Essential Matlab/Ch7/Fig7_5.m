clf
hold on
subplot(2,2,1)
x = 0.01:0.001:0.1;
plot(x, sin(1./x)), title('(a)')
subplot(2,2,2)
x = 0.01:0.0001:0.1;
plot(x, sin(1./x)), title('(b)')
hold off
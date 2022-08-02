x =  linspace(0, 5*pi, 500);
y =  sin(x);
u =  1-cos(x(1:5:end)); 
z =  cumtrapz(x, y);
subplot(1, 2, 1); plot(x, y);
legend('sinus', 4)
subplot(1, 2, 2); plot(x, z, 'r-', x(1:5:end), u, 'bo')
legend('trapz', 'primitive', 4)
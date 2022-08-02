theta = linspace(0, 2*pi, 500);
x = 1.5*cos(theta); y = 1.5*sin(theta); 
subplot(1, 5, 1);  plot(x, y);
subplot(1, 5, 2);  plot(x, y);  axis tight
subplot(1, 5, 3);  plot(x, y);  axis equal
subplot(1, 5, 4);  plot(x, y);  axis square
subplot(1, 5, 5);  plot(x, y);  axis off
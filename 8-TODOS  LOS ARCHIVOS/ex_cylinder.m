subplot(1,4,1)
cylinder, axis square tight
subplot(1,4,2)
cylinder([0 1 2 3 4 3 2 1 0],50), axis square tight
x = linspace(0,5*pi,500);
y = abs((5*pi-x).*sin(x)+2);
subplot(1,4,4)
cylinder(y,50); colormap(gray); shading interp
axis square tight
subplot(1,4,3)
sphere(50), axis square tight
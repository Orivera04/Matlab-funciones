z = peaks(20);
subplot(1,3,1)
surf(z), shading interp, colormap(gray)
daspect([1,1,1]) % défaut
subplot(1,3,2)
surf(z), shading interp, colormap(gray)
daspect([2,2,1])
subplot(1,3,3)
surf(z), shading interp, colormap(gray)
daspect([1,2,2])
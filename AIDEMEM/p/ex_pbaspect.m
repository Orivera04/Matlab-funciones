z = peaks(18);
subplot(1,3,1)
surf(z), shading interp, colormap(gray)
pbaspect([1,1,1]) % défaut
subplot(1,3,2)
surf(z), shading interp, colormap(gray)
pbaspect([2,2,1])
subplot(1,3,3)
surf(z), shading interp, colormap(gray)
pbaspect([1,2,2])
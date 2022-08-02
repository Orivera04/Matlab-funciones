f = inline('sin(abs(z)/20).*exp(-abs(z))');
x= linspace(-2, 2, 40); [xx, yy]= meshgrid(x);
zz = f(xx+i*yy);
subplot(1,2,1)
surf(xx,yy,zz); colormap(gray);view(45,37.5), shading interp
title('\bfcaché', 'fontsize', 18)
subplot(1,2,2)
h=surf(xx,yy,zz); colormap(gray);view(45,37.5), shading interp
alpha(0.5)
title('\bfsemi-transparent', 'fontsize', 18)
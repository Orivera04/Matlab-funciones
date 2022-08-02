f = inline('sin(abs(z)/20).*exp(-abs(z))');
x= linspace(-2, 2, 20);
[xx, yy]= meshgrid(x);
zz = f(xx+i*yy);
subplot(1,3,1)
surf(xx,yy,zz); colormap(gray);shading('interp');view(45,37.5)
title('\bfinterp', 'fontsize', 18)
subplot(1,3,2)
surf(xx,yy,zz); colormap(gray);shading('flat');;view(45,37.5)
hidden off
title('\bfflat', 'fontsize', 18)
subplot(1,3,3)
surf(xx,yy,zz); colormap(gray);shading('faceted');;view(45,37.5)
hidden off
title('\bffaceted', 'fontsize', 18)

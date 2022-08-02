f = inline('(1./(eps+abs(1-z.^4))).*(abs(1-z.^4)>0.01)+10*(abs(1-z.^4)<=0.01)');
f = inline('sin(abs(z)/20).*exp(-abs(z))');
x= linspace(-2, 2, 40);
[xx, yy]= meshgrid(x);
zz = f(xx+i*yy);
subplot(1,2,1)
mesh(xx,yy,zz); colormap(gray);view(45,37.5)
title('\bfcaché', 'fontsize', 18)
subplot(1,2,2)
mesh(xx,yy,zz); colormap(gray);view(45,37.5)
hidden off
title('\bfnon caché', 'fontsize', 18)
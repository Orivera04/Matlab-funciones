x = linspace(0, 5*pi, 20);
y = x.*sin(x);
subplot(1,3,1)
stairs(x,y);
title('\bfstairs', 'fontsize', 18);
subplot(1,3,2)
stem(x,y);
title('\bfstem', 'fontsize', 18);
[xx, yy] = meshgrid(x);
zz = xx.^2+yy.^2;
subplot(1,3,3)
stem3(xx, yy, zz);
title('\bfstem3', 'fontsize', 18);
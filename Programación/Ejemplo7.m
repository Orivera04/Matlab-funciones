[X,Y,Z]=sphere(60);
subplot(121)
surf(X,Y,Z,'facecolor',[0.4 0.9 0.6])
daspect([1 1 1]) % aspecto [1 1 1]
title('La esfera','fontsize',14)
subplot(122);
surf(X,Y,Z)
title('la esfera','fontsize',14)
colormap('bone')
colorbar('or') % barra de colores horizontal
daspect([1 1 1]) % aspecto [1 1 1]
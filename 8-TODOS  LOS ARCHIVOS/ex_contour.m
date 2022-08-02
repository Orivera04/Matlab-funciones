  g = inline('(x.*x-2.*y.*y).*exp(-2.*x.*x-y.*y)');
  colormap(gray)
  [x,y]=meshgrid(linspace(-2,2,50)); z = g(x,y);
  subplot(1,4,1);   contour(x,y,z);
  title({'Lignes de niveau',' (contour) '}, 'fontsize',14);
  subplot(1,4,2);   contour3(x,y,z);
  title({'Lignes de niveau 3D', ' (contour3)'}, 'fontsize',14);
  subplot(1,4,3);   [cs, h] = contour(x,y,z);
  clabel(cs,h);
  title({'Lignes de niveau', ' avec label (clabel)'}, 'fontsize',14);
  subplot(1,4,4);
  contourf(x,y,z); hold on
  [c,h]=contour(x,y,z,'k-'); clabel(c,h);
  title({'Remplissage',' (contourf)'}, 'fontsize',14);
  

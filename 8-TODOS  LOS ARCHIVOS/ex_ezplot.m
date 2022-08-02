subplot(1,4,1); ezplot('x^3-y^2+1'); hold on
                ezplot('x*y^2-3*x-4*y'); 
title('fonction implicite', 'fonts', 14); axis square
subplot(1,4,2); ezplot('sin(3*t)','cos(5*t)', [-3*pi,3*pi]);
title({'fonction','paramètrique'}, 'fonts', 14); axis square
subplot(1,4,3); ezsurf('sin(x+y)',[0 pi 0 pi]);colormap(gray)
title('surface', 'fonts', 14); axis square
subplot(1,4,4); ezpolar('t',[0, 2*pi]);
title('courbe polaire', 'fonts', 14); axis square


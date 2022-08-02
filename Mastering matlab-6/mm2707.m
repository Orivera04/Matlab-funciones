subplot(2,2,1)
sphere
colormap(gray)
light
shading interp
axis square off
material default
title('Figure 27.7a: Default Material')

subplot(2,2,2)
sphere
light
shading interp
axis square off
material shiny
title('Figure 27.7b: Shiny Material')

subplot(2,2,3)
sphere
light
shading interp
axis square off
material dull
title('Figure 27.7c: Dull Material')

subplot(2,2,4)
sphere
light
shading interp
axis square off
material metal
title('Figure 27.7d: Metal Material')

subplot(2,2,1)
sphere
light
shading interp
axis square off
lighting none
title('Figure 27.6a: No Lighting')

subplot(2,2,2)
sphere
light
shading interp
axis square off
lighting flat
title('Figure 27.6b: Flat Lighting')

subplot(2,2,3)
sphere
light
shading interp
axis square off
lighting gouraud

title('Figure 27.6c: Gouraud Lighting')

subplot(2,2,4)
sphere
light
shading interp
axis square off
lighting phong
title('Figure 27.6d: Phong Lighting')

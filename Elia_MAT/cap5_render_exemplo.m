function cap5_render_exemplo ( )
% Superficie
x=-pi:0.5:pi;
y=-pi:0.5:pi;
[MX,MY]=meshgrid(x,y);
MZ=cos(MX)+sin(MY);
subplot(2,1,1)
surf(MZ)
title('Original')
% Mapa de cor
subplot(2,1,2)
surf(MZ)
title('Com Luz e Sombreamento')
colormap bone
% Luz phong
light 
lighting phong
% Sombra interp
shading interp

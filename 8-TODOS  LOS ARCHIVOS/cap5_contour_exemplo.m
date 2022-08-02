% cap5_contour_exemplo
x=-pi:0.5:pi;
y=-pi:0.5:pi;
[MX,MY]=meshgrid(x,y);
MZ=cos(MX)+sin(MY);
subplot(2,2,1)
surf(MZ)
title('Superficie')
subplot(2,2,2)
contour(MZ)
title('Curvas 2D')
subplot(2,2,3)
contour3(MZ)
title('Curvas 3D')
subplot(2,2,4)
contourf(MZ)
title('Curvas preenchidas')
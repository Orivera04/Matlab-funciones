% cap5_mesh_exemplo
x=-pi:0.5:pi;
y=-pi:0.5:pi;
[MX,MY]=meshgrid(x,y);
MZ=cos(MX)+sin(MY);
subplot(2,2,1)
meshc(MX,MY,MZ)
title('Meshc')
subplot(2,2,2)
surf(MX,MY,MZ)
title('Surf')
subplot(2,2,3)
surfc(MX,MY,MZ)
title('Surfc')
subplot(2,2,4)
waterfall(MX,MY,MZ)
title('Waterfall')

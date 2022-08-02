% cap3_alfa_exemplo
x=-pi:0.5:pi;
y=-pi:0.5:pi;
[MX,MY]=meshgrid(x,y);
MZ=cos(MX)+sin(MY);
subplot(1,3,1)
surf(MX,MY,MZ)
title('Original')
subplot(1,3,2)
surf(MX,MY,MZ)
alpha(0.4)
title('Alpha 0.4')
subplot(1,3,3)
surf(MX,MY,MZ)
% brighten(0.9)
title('Brighten 0.9')

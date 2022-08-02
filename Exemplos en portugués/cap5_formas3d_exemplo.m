% cap5_formas3d_exemplo
[MX1,MY1,MZ1]=cylinder([1 0.5 1],20);
[MX2,MY2,MZ2]=ellipsoid(0,0,0,0.5,0.1,3,20);
[MX3,MY3,MZ3]=peaks(10);
[MX4,MY4,MZ4]=sphere(20);
subplot(2,2,1)
surf(MX1,MY1,MZ1)
title('Cylinder')
subplot(2,2,2)
surf(MX2,MY2,MZ2)
title('Ellipsoid')
subplot(2,2,3)
surf(MX3,MY3,MZ3)
title('Peaks')
subplot(2,2,4)
surf(MX4,MY4,MZ4)
title('Sphere')

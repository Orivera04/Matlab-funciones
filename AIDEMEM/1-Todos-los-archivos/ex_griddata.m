f = inline('exp(-x.*x -y.*y)','x','y');
x1 = linspace(-1,1,30);
y1 = x1;
[x0, y0] = meshgrid(x1,y1);
subplot(1,3,1);
mesh(x0,y0,f(x0,y0)); 
title('surface originale','fonts',14)
x = 2*rand(1,200)-1; y = 2*rand(1,200)-1;
z = f(x,y);
[xx, yy, zz]=griddata(x,y,z,x1(:)',y1(:));
subplot(1,3,2);
plot3(x,y,z,'r+')
title('points épars', 'fonts',14)
subplot(1,3,3);
mesh(xx, yy, zz); hold on %shading('interp');
plot3(x,y,z,'r+')
title('surface reconstituée','fonts',14)

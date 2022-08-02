warning off 
% pour éviter les messages lors de divisions par zéro
x = [-1 1 -1 1 0 0 1]
y = [-1 -1 1 1 0 1 0]
z1 =  atan(y./x)
z2 =  atan2(y, x)
x = linspace(-0.5, 0.5, 30);
[xx,  yy] = meshgrid(x); surf(xx, yy, atan2(yy, xx));
colormap(gray);  shading interp; brighten(-0.6)
 
x = (2*rand(1,200)-1)*sqrt(pi/2);
y = (2*rand(1,200)-1)*sqrt(pi/2);
x1 = linspace(-1,1,100)*sqrt(pi);
f = inline('sin(x.*x+y.*y)','x','y');
subplot(1,4,1)
[x0, y0] = meshgrid(x1);
surf(x0,y0,f(x0,y0)); colormap(gray); shading interp
subplot(1,4,2)
z = f(x,y);
[xx, yy, zz]=griddata(x,y,z,x1(:)',x1(:));
surf(xx, yy, zz);colormap(gray); shading interp
subplot(1,4,3)
t = delaunay(x,y,z);
trisurf(t, x, y, z);colormap(gray); shading interp
subplot(1,4,4)
trimesh(t, x, y, z);
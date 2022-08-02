f = inline('(sin(x.^2+y.^2-z.^2)/20).*exp(-(x.^2+y.^2+z.^2))', ...
     'x','y','z');
x= linspace(-2, 2, 21); [xx, yy, zz]= meshgrid(x,x,x);
z = f(xx,yy,zz);
iso = linspace(min(z(:)),max(z(:)),5);
for i = 2:4
  figure(i)
  isosurface(xx,yy,zz,z, iso(i));view(80,60);
  colormap(gray); lighting phong; axis off;
end;

f = inline('sin((x.^2+y.^2+z.^2)/20).*exp(-(x.^2+y.^2+z.^2))',...
	   'x','y','z');
x= linspace(-2, 2, 20); z= linspace(-1, 1, 20);
[xx, yy, zz]= meshgrid(x, x, z);
v = f(xx,yy,zz);
subplot(1,2,1)
slice(xx,yy, zz, v,-1:1:1, -1:1:1, 0); colormap(gray);view(45,37.5)
subplot(1,2,2)
contourslice(xx,yy, zz, v,-1:1:1, -1:1:1, 0); colormap(gray);view(45,37.5)

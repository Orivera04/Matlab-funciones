f = inline('(x+y).*sin(pi*sqrt(x.^2+y.^2))', 'x', 'y');
x = linspace(-3,3,31);
[xi yi]=meshgrid(x); zi = f(xi,yi);
subplot(1,4,1); mesh(xi,yi,zi); colormap(gray);
subplot(1,4,2); meshc(xi,yi,zi); colormap(gray);
subplot(1,4,3); meshz(xi,yi,zi); colormap(gray);
subplot(1,4,4); waterfall(xi,yi,zi); colormap(gray);  
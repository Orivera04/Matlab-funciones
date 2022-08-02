function mandelbrot
% MANDEL.M Produces a plot of the famous Mandelbrot set.
% see: http://eulero.ing.unibo.it/~strumia/Mand.html
% The generator is z = z^2 + z0.  Try changing the parameters:
N = 400; 
xcentre = -0.6; 
ycentre = 0; 
L = 1.5; 
x = linspace(xcentre - L,xcentre + L,N); 
y = linspace(ycentre - L,ycentre + L,N);
[X,Y] = meshgrid(x,y); 
Z = X + i*Y; 
Z0 = Z;
for k = 1:50; 
  Z = Z.^2 + Z0;
end 
ind1 = find(isnan(Z));
ind2 = find(~isnan(Z));
Z(ind1) = 1;
Z(ind2) = 0;
contour(x,y,abs(Z),[.5 .5])
grid;box
axis equal off

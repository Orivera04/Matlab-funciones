%  book_4_68.m

load soil

%  reduce the amount of data for faster computation
factor = 3;
Easting = Easting(1:factor:end);
Northing = Northing(1:factor:end);
Resistivity = Resistivity(1:factor:end);



%  define colormap to match book
white = [1 1 1];
cyan = [0 1 1];
magenta = [1 0 1];
myMap = [magenta; 0.8*magenta+0.2*white; 0.6*magenta+0.4*white;...
      0.4*magenta+0.6*white; 0.2*magenta+0.8*white;...
      0.2*cyan+0.8*white; 0.4*cyan+0.6*white;...
      0.6*cyan+0.4*white; 0.8*cyan+0.2*white; cyan];

%  loess surface fit parameters
alpha = 0.25;
lambda = 2;

%  smooth and grid the data
XI = 0.15:0.05:1.41;
YI = (0.15:0.05:3.645)';
nx = length(XI);
ny = length(YI);
newx = repmat(XI,ny,1);
newy = repmat(YI,1,nx);
newz = loess2(Easting,Northing,Resistivity,newx,newy,alpha,lambda);

%  make filled contour plot
contourLevel = linspace(10,90,9);
contourf(newx,newy,newz,contourLevel);
colormap(myMap)
shading flat
axis('equal')
xlabel('Easting (km)')
ylabel('Northing (km)')
title('Soil')
set(gca,'XTick',[0.2 0.6 1.0 1.4])
colorbar
axis tight
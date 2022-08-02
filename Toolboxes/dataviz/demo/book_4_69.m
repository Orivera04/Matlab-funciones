%  book_4_69.m

load soil

%  reduce the amount of data for faster computation
factor = 3;
Easting = Easting(1:factor:end);
Northing = Northing(1:factor:end);
Resistivity = Resistivity(1:factor:end);

%  loess parameters
alpha = 0.2;
lambda = 2;

%  smooth and grid the data
XI = 0.15:0.05:1.41;
YI = (0.15:0.05:3.645)';
nx = length(XI);
ny = length(YI);
newx = repmat(XI,ny,1);
newy = repmat(YI,1,nx);
newz = loess2(Easting,Northing,Resistivity,newx,newy,alpha,lambda);

%  set perspective and lighting
az = 0;
el = 45;
s = [-90 60];
cla
hold on
view(az,el)
%  make surface plot with lighting
surfl(newx,newy,newz,s);
hold off
set(gca,'Projection','perspective')
shading interp
colormap(gray)
set(gca,'CameraPosition',[0.8 -3 200])
xlabel('Easting (km)')
ylabel('Northing (km)')
title('Soil')

%  alt_4_50.m

load galaxy

contourValue = 1440:40:1760;

%  grid the data
XI = -25:1:25;
YI = (-45:1:45)';
[XI,YI,ZI] = griddata(EastWest,NorthSouth,Velocity,XI,YI);

contour(XI,YI,ZI,contourValue)
xlabel('East-West Coordinate (arcsec)')
ylabel('North-South Coordinate (arcsec)')
title('Galaxy')
axis image
colorbar
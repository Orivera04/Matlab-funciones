%  book_4_50.m
%  calls loess2

load galaxy

contourValue = 1420:20:1780;
contourLabel = 1440:40:1760;
alpha = 0.25;
lambda = 2;

%  smooth and grid the data
XI = -25:2:25;
YI = (-45:2:45)';
nx = length(XI);
ny = length(YI);
newx = repmat(XI,ny,1);
newy = repmat(YI,1,nx);
newz = loess2(EastWest,NorthSouth,Velocity,newx,newy,alpha,lambda,1);

[c,h] = contour(newx,newy,newz,contourValue);
hg = clabel(c,h,contourLabel);
set(hg,'FontSize',8)
xlabel('East-West Coordinate (arcsec)')
ylabel('North-South Coordinate (arcsec)')
title('Galaxy')
axis image

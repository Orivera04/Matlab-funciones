%  alt_4_50d.m
%  filled contour of galaxy data with consistent colorbar
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

%  make filled contour plot
contourf(newx,newy,newz,contourValue);
xlabel('East-West Coordinate (arcsec)')
ylabel('North-South Coordinate (arcsec)')
title('Stellar Velocity')
axis image

%  plot data locations
hold on
hg = plot(EastWest,NorthSouth,'k.');
set(hg,'MarkerSize',5)
hold off
hgb = colorbar;
set(hgb,'YDir','reverse')
pos = get(hgb,'Position');
pos(2) = 1.21*pos(2);
pos(4) = 0.95*pos(4);
set(hgb,'Position',pos)
set(get(hgb,'XLabel'),'String','km/sec')

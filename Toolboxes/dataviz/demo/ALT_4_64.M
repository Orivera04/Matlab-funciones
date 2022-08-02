%  alt_4_64.m

load soil

XI = 0.15:0.05:1.41;
YI = (0.15:0.05:3.645)';
ZI = griddata(Easting,Northing,Resistivity,XI,YI);
Zmin = min(ZI(:));
ZI = ZI-Zmin;
Zmax = max(ZI(:));
ZI = ZI/Zmax;
nc = 32;
ZI = ZI*(nc-1)+1;

image(XI,YI,ZI)
colormap(hot(nc))
axis xy
axis equal
set(gca,'XTick',[0.2 0.6 1.0 1.4])
hg = colorbar;
xlabel('Easting (km)')
ylabel('Northing (km)')
title('Soil')
axis tight

%  put meaningful labels on colorbar
barTick = get(hg,'YTick');
barLabel = round(Zmax*barTick/32+Zmin);
set(hg,'YTickLabel',barLabel)

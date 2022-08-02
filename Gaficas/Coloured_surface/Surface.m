%WARNING WORKSPACE WILL BE CLEARED

clc
clear all
close all



%load points 3D array and rgb data
load ScannerData.mat

%now we have the points coordinate in the p variable
% rgb values in the C variable. Colors are referred to points location






%since the surface is in the z=f(x,y) form we just need to build a
%triangulation in 2D space.
%tesselate the points using only x and y coordinates
t=delaunay(p(:,1),p(:,2));




colormap(C);%build a colormap
%now each point has his own color
%point 1-> first row of C


figure(1)
axis equal
hold on
%trisurf automatically make points->Colormap association
%we just need to give the color map index 1:size(p,1)
trisurf(t,p(:,1),p(:,2),p(:,3),1:size(p,1),'edgecolor','none')


shading interp %colours are interpolated inside triangles

%that's all!!!!!!


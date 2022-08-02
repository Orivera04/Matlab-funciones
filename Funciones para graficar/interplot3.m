function handl = interplot3(x,y,z,gridsize);
%INTERPLOT3 -Plot surface for any 3D data.
%function interplot3(x,y,z,gridsize);
%
% Plot Z as a function of X,Y. This is done by nearest neighbour
% interpolation onto a grid. The number of points on
% the grid is GRIDSIZE*GRIDSIZE. This defaults to 100x100 if GRIDSIZE is omitted.
%
% Plots figure and returns a handle to a surf axis.
%
% Requires the KDTREE toolbox by Guy Schechter. Available from
%
% http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=4586&objectType=file
%
% (c) Copyright 2005 Amos Storkey, University of Edinburgh.
%

%Set defaults.
if nargin<4
  GRIDSIZE=100;
end

%Get ranges for the data
xvals = min(x) : (max(x)-min(x))/gridsize : max(x)*1.0001;
yvals = min(y) : (max(y)-min(y))/gridsize : max(y)*1.0001;
%Build interpolation vectors
[x1,y1] = meshgrid(xvals, yvals);
xy = [x, y];
x1y1 = [x1(:), y1(:)];
%Find nearest neighbours
idx = kdtreeidx(xy,x1y1);
%Get actual z values at the grid points
z1 = z(idx);
%Plot the nearest neighbour interplotated surface
handl = surf(xvals, yvals, reshape(z1,length(xvals), length(yvals)));

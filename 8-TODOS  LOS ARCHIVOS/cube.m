function hc=cube(coord,d,c,alpha);

% CUBE plot a 3D box at given front bottom left angle coordinates and
% tri-dimensional range vector (dx, dy, dz). You can 
%
%Usage
%   hc=cube(start,size,color,alpha);
%
%   will draw a voxel at 'start' of size 'size' of color 'color' and
%   transparency 'alpha' (1 for opaque, 0 for transparent)
%
%   INPUTS :
%       start is a 1-by-3 element vector [x,y,z]
%       size the a 1-by-3 element vector [dx,dy,dz]
%       color is a 8-by-1 vector (one value by vertex) of color index in colormap. 
%       (see help about Indexed Color Data)
%       alpha : define transparency (between 0 & 1 : 0 = transparent, 1 = opaque).
%
%   OUTPUT :
%       hc : handles of 'voxel' object.
%
%
%   R.Brégeon le 16/09/2004
%

x0=coord(1);
y0=coord(2);
z0=coord(3);
dx=d(1);
dy=d(2);
dz=d(3);
M=[[x0 y0 z0];[x0+dx y0 z0];[x0+dx y0+dy z0];[x0 y0+dy z0];[x0 y0 z0+dz];[x0+dx y0 z0+dz];...
    [x0+dx y0+dy z0+dz];[x0 y0+dy z0+dz]];
N=[[1 2 6 5];[2 3 7 6];[3 4 8 7];[4 1 5 8];[1 2 3 4];[5 6 7 8]];

hc=patch('Vertices',M,'Faces',N,'FaceColor','flat','FaceAlpha',alpha,'EdgeColor','flat',...
     'FaceVertexCData',c,'EdgeAlpha',1,'CDataMapping','direct');

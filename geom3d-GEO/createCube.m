function [nodes, edges, faces] = createCube()
%CREATECUBE create a 3D cube
%
%   c = CREATECUBE create a unit cube, as a polyhedra representation.
%   c has the form [n, e, f], where n is a 8*3 array with vertices
%   coordinate, e is a 12*2 array containing indices of neighbour vertices,
%   and f is a 6*4 array containing vertices array of each face.
%
%   ---------
%
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 10/02/2005.
%

%   HISTORY
%   04/01/2007: remove unused variables

x0 = 0; dx= 1;
y0 = 0; dy= 1;
z0 = 0; dz= 1;

nodes = [...
    x0 y0 z0; ...
    x0+dx y0 z0; ...
    x0 y0+dy z0; ...
    x0+dx y0+dy z0; ...
    x0 y0 z0+dz; ...
    x0+dx y0 z0+dz; ...
    x0 y0+dy z0+dz; ...
    x0+dx y0+dy z0+dz];

edges = [1 2;1 3;1 5;2 4;2 6;3 4;3 7;4 8;5 6;5 7;6 8;7 8];

faces = [1 2 4 3;5 6 8 7;2 4 8 6;1 3 7 5;1 2 6 5;3 4 8 7];


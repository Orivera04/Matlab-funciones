function [nodes, edges, faces] = createTetrahedron()
%CREATETETRAHEDRON create a tetrahedron  with 4 vertices and faces
%
%   c = CREATECUBE create a unit cube, as a polyhedra representation.
%   c has the form [n, e, f], where n is a 4*3 array with vertices
%   coordinate, e is a 6*2 array containing indices of neighbour vertices,
%   and f is a 4*3 array containing vertices array of each (triangular)
%   face.
%
%   ---------
%
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 21/03/2005.
%

%   HISTORY
%   04/01/2007: remove unused variables

x0 = 0; dx= 1;
y0 = 0; dy= 1;
z0 = 0; dz= 1;

nodes = [...
    x0 y0 z0; ...
    x0+dx y0+dy z0; ...
    x0+dx y0 z0+dz; ...
    x0 y0+dy z0+dz];

edges = [1 2;1 3;1 4;2 3;3 4;4 2];

faces = [1 2 3;1 3 4;1 4 2;4 3 2];


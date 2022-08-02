function [nodes, edges, faces] = createCubeOctahedron()
%CREATECUBEOCTAHEDRON create a cube-octahedron
%
%   c = createCubeOctahedron create a unit cube, as a polyhedra representation.
%   c has the form [n, e, f], where n is a 6*3 array with vertices
%   coordinate, e is a 12*2 array containing indices of neighbour vertices,
%   and f is a 8*3 array containing vertices array of each face.
%
%   ---------
%
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 10/02/2005.
%

%   HISTORY
%   04/01/2007: remove unused variables

nodes = [...
    0 -1 1;1 0 1;0 1 1;-1 0 1; ...
    1 -1 0;1 1 0;-1 1 0;-1 -1 0;...
    0 -1 -1;1 0 -1;0 1 -1;-1 0 -1];

edges = [...
    1 2;1 4;1 5;1 8;2 3;2 5;2 6;3 4;3 6;3 7;4 7;4 8;...
    5 6;5 8;5 9;5 10;6 7;6 10;6 11;7 8;7 11;7 12;8 9;8 12;...
    9 10;10 11;11 12];

faces = {...
    [1 2 3 4], [1 5 2], [2 6 3], [3 7 4], [4 8 1], ...
    [5 10 6 2], [3 6 11 7], [4 7 12 8], [1 8 9 5], ...
    [5 9 10], [6 10 11], [7 11 12], [8 12 9], [9 12 11 10]};


function [nodes, edges, faces] = createOctahedron()
%CREATEOCTAHEDRON create an octahedron
%
%   c = createOtahedron create a unit cube, as a polyhedra representation.
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

nodes = [1 0 0;0 1 0;-1 0 0;0 -1 0;0 0 1;0 0 -1];

edges = [1 2;1 4;1 5; 1 6;2 3;2 5;2 6;3 4;3 5;3 6;4 5;4 6];

faces = [1 2 5;2 3 5;3 4 5;4 1 5;1 2 6;2 3 6;3 4 6;4 1 6];


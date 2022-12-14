function [nodes, edges, faces] = createTetrakaidecahedron()
%CREATETETRAKAIDECAHEDRON create a tetrakaidecahedron
%
%   c = createTetrakaidecahedron
%   c has the form [n, e, f], where n is a 24x3 array with vertices
%   coordinate, e is a 36x2 array containing indices of neighbour vertices,
%   and f is a 14x1 cell array containing vertices array of each face.
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
    1 0 2;0 1 2;-1 0 2;0 -1 2;...
    2 0 1;0 2 1;-2 0 1;0 -2 1;...
    2 1 0;1 2 0;-1 2 0;-2 1 0;-2 -1 0;-1 -2 0;1 -2 0;2 -1 0;...
    2 0 -1;0 2 -1;-2 0 -1;0 -2 -1;...
    1 0 -2;0 1 -2;-1 0 -2;0 -1 -2];



edges = [...
    1 2;1 4;1 5;2 3;2 6;3 4;3 7;4 8;...
    5 9;5 16;6 10;6 11;7 12;7 13;8 14;8 15;...
    9 10;9 17;10 18;11 12;11 18;12 19;13 14;13 19;14 20;15 16;15 20;16 17;....
    17 21;18 22;19 23;20 24;21 22;21 24;22 23;23 24];
    
    
faces = {...
    [1 2 3 4], ...
    [1 4 8 15 16 5], [1 5 9 10 6 2], [2 6 11 12 7 3], [3 7 13 14 8 4],...
    [5 16 17 9], [6 10 18 11], [7 12 19 13], [8 14 20 15],...
    [9 17 21 22 18 10], [11 18 22 23 19 12], [13 19 23 24 20 14], [15 20 24 21 17 16], ...
    [21 24 23 22]};
faces = faces';
    


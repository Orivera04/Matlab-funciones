% indices = triangulate(vertices[,epsilon])
%
% where `vertices' is a 3xN double matrix, with each column
% representing a vertex in three-dimensional space.
% triangulate will construct a list of triangles that
% together form a surface interpolating all of the supplied
% vertices. the output surface is of the form z=f(x,y).
%
% the triangle list is passed back as a list of
% indices into the vertex list. that is, `indices' is a 3xM
% int32 array, with each column holding the indices of three
% columns of `vertices'. each triangle is specified
% clockwise (looking from above).
%
% `epsilon' is the tolerance to decide if a vertex falls on
% an existing edge; it defaults to eps - this is unlikely to
% be a sensible value if the vertex set has some regularity
% in it.
%
% NOTE: for correct operation it is important that the list
% is sorted correctly before passing in; it should be sorted
% by x coordinate first, then y, then z. see `triangulate_demo'
% to find out how to sort, and to see how to use triangulate.
%
% ported from Paul Bourke's triangulate code at
% http://astronomy.swin.edu.au/~pbourke/terrain/triangulate/

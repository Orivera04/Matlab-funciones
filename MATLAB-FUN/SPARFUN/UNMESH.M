function [A,xy] = unmesh(M)
%UNMESH	Convert a list of mesh edges to a graph or matrix.
%	[A,xy] = UNMESH(M)
%
%	Input:
%	  Each row of M is a mesh edge in two dimensions, [x1 y1 x2 y2].
%
%	Output:
%	  A is the Laplacian matrix of the mesh (the symmetric adjacency matrix 
%	       with -1 for edges and degrees on diagonal).
%	  Each row of xy is a coordinate [x y] of a mesh point.
%
%	See also GPLOT.

%	John Gilbert, 1990.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Discretize x and y with "range" steps, 
% equating coordinates that round to the same step.


range = round(eps^(-1/3));

[m,k] = size(M);
if k ~= 4, error ('Mesh must have rows of the form [x1 y1 x2 y2].'), end;

x = [ M(:,1) ; M(:,3) ];
y = [ M(:,2) ; M(:,4) ];
xmax = max(x);
ymax = max(y);
xmin = min(x);
ymin = min(y);
xscale = (range-1) / (xmax-xmin);
yscale = (range-1) / (ymax-ymin);

% The "name" of each (x,y) coordinate (i.e. vertex)
% is scaledx + scaledy/range .

xnames = round( (x - xmin*ones(2*m,1)) * xscale );
ynames = round( (y - ymin*ones(2*m,1)) * yscale );
xynames = xnames+1 + ynames/range;

% vnames = the sorted list of vertex names, duplicates removed.

vnames = sort(xynames);
f = find(diff( [-Inf; vnames] ));
vnames = vnames(f);
n = length(vnames);
disp ([int2str(n) ' vertices:']);

% x and y are the rounded coordinates, un-scaled.

x = (floor(vnames) / xscale) + xmin;
y = ((vnames-floor(vnames)) / yscale) * range + ymin;
xy = [x y];

% Fill in the edge list one vertex at a time.

ij = zeros(2*m,1);
for v = 1:n,
    if ~rem(v,10),
        disp ([int2str(v) '/' int2str(n)]);
    end;
    f = find( xynames == vnames(v) );
    ij(f) = v*ones(length(f),1);
end;
if rem(n,10), disp ([int2str(n) '/' int2str(n)]); end;

% Fill in the edges of A.

i = ij(1:m);
j = ij(m+1:2*m);
A = sparse(i,j,1,n,n);

% Make A the symmetric Laplacian.

A = -spones(A+A');
A = A - diag(sum(A));



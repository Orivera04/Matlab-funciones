function [Xout,Yout]=gplot(A,xy,lc)
%GPLOT 	Plot a "graph theoretic" graph.
%	GPLOT(A,xy) plots the graph specified by A and xy.
%	A graph, G, is a set of nodes numbered from 1 to n,
%	and a set of connections, or edges, between them.
%	In order to plot G, two matrices are needed.
%	The adjacency matrix, A, has a(i,j) nonzero if and
%	only if node i is connected to node j.  The coordinates
%	array, xy, is an n-by-2 matrix with the position for
%	node i in the i-th row, xy(i,:) = [x(i) y(i)].
%	
%	GPLOT(A,xy,lc) uses line type and color instead of the 
%	default, 'r-'.   For example, lc = 'g:'.  See PLOT.
%
%	[X,Y] = GPLOT(A,xy) returns the NaN-punctuated vectors
%	X and Y without actually generating a plot. These vectors
%	can be used to generate the plot at a later	time if desired.
%	
%	See also SPY, TREEPLOT, UNMESH.

%	John Gilbert, 1991.
%	Modified 1-21-91, LS; 2-28-92, 6-16-92 CBM.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin < 3, 
    lc = 'r-';
end;

[i,j] = find(A);
[ignore, p] = sort(max(i,j));
i = i(p);
j = j(p);

% Create a long, NaN-seperated list of line segments,
% rather than individual segments.

X = [ xy(i,1) xy(j,1) NaN*ones(size(i))]';
Y = [ xy(i,2) xy(j,2) NaN*ones(size(i))]';
X = X(:);
Y = Y(:);

if nargout==0,
    plot(X, Y, lc);
    % Use RETURN to suppress the output
    return;
end;

Xout = X;
Yout = Y;

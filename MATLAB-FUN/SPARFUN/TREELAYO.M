function [x,y,h,s] = treelayout(parent,post)
%TREELAYOUT Lay out a tree or forest.
%	[x,y,h,s] = treelayout(parent,post)
%	    parent is the vector of parent pointers, with 0 for a root.
%	    post is a postorder permutation on the the tree nodes.
%	    (If post is omitted we compute it here.)
%	    x and y are vectors of coordinates in the unit square at which 
%	    to lay out the nodes of the tree to make a nice picture.
%	    Optionally, h is the height of the tree and s is the 
%	    number of vertices in the top-level separator.
%
%	See also ETREE, TREEPLOT, ETREEPLOT.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

% This is based on the C code in sptrees.c by John Gilbert.
% Leaves are spaced evenly on the x axis, and internal
% nodes are centered over their descendant leaves with
% y coordinate proportional to height in the tree.

n = max(size(parent));

if nargin < 2,

    % Create the adjacency matrix A of the given tree,
    % and get the postorder with another call to etree.

    j = find(parent);
    A = sparse (parent(j), j, 1, n, n);
    A = A + A' + speye(n,n);
    [ignore, post] = etree(A);

end;

% Add a dummy root node #n+1, and identify the leaves.

parent = rem (parent+n, n+1) + 1;  % change all 0s to n+1s
isaleaf = ones(1,n+1);
isaleaf(parent) = zeros(n,1);

% In postorder, compute heights and descendant leaf intervals.
% Space leaves evenly in x (in postorder).

xmin = n*ones(1,n+1);
xmax = zeros(1,n+1);
height = zeros(1,n+1);
nkids = zeros(1,n+1);
nleaves = 0;

for i = 1:n,
    node = post(i);
    if isaleaf(node),
        nleaves = nleaves+1;
        xmin(node) = nleaves;
        xmax(node) = nleaves;
    end;
    dad = parent(node);
    height(dad) = max (height(dad), height(node)+1);
    xmin(dad)   = min (xmin(dad),   xmin(node));
    xmax(dad)   = max (xmax(dad),   xmax(node));
    nkids(dad)  = nkids(dad)+1;
end;

% Compute coordinates, leaving a little space on all sides.

treeht = height(n+1) - 1;
deltax = 1/(nleaves+1);
deltay = 1/(treeht+2);
x = deltax * (xmin+xmax)/2;
y = deltay * (height+1);

% Omit the dummy node.

x = x(1:n);
y = y(1:n);

% Return the height and top separator size.

h = treeht;
s = n+1 - max(find(nkids~=1));

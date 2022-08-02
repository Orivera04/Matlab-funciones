function [p,q] = etree(A,f)
%ETREE	Elimination tree of a matrix.
%	p = etree(A) returns an elimination tree for the square
%	symmetric matrix whose upper triangle is that of A.
%	p(j) is the parent of column j in the tree, 
%	or 0 if j is a root.
%
%	p = etree(A,'col') returns the elimination tree of A'*A.
%	p = etree(A,'sym') is the same as p = etree(A).
%
%	[p,q] = etree(...) also returns a postorder permutation q on the tree.
%
%	See also TREELAYOUT, TREEPLOT, ETREEPLOT.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin <= 1,
    [p,q] = sparsfun('symetree',A);
elseif f(1) == 's' | f(1) == 'S',
    [p,q] = sparsfun('symetree',A);
elseif f(1) == 'c' | f(1) == 'C',
    [p,q] = sparsfun('coletree',A);
else 
    error ('Second input argument must be ''sym'' or ''col''');
end

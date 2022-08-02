function etreeplot(A,c,d)
%ETREEPLOT Plot the elimination tree.
%	etreeplot(A):  Plot the elimination tree of A (or A+A', if asymmetric).
%	etreeplot(A,c,d):  See treeplot for optional parameters c and d.
%
%	See also TREEPLOT, ETREE, TREELAYOUT.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

B = spones(A);
if nargin == 1,
    treeplot(etree(B+B'));
elseif nargin == 2,
    treeplot(etree(B+B'),c);
else
    treeplot(etree(B+B'),c,d);
end

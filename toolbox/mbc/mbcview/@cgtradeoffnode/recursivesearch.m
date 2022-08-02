function p=recursivesearch(obj,data)
%RECURSIVESEARCH  Search tree for nodes related to data
%
%  P = RECURSIVESEARCH(ND, DATA)  searchs down the tree from ND and returns
%  a list of node pointers that are related to DATA.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:38:35 $

p = null(xregpointer, 0);
if isa(data, 'xregpointer')
    if any(data==obj.Tables) ...
            || any(data==obj.FillExpressions) ...
            || any(data==obj.FillMaskExpressions) ...
            || any(data==obj.GraphExpressions)
        p = address(obj);
    end
end

% Only search sub-nodes that are rables
ch = getTableNodes(obj);
for n = 1:length(ch)
    p = [p ch(n).recursivesearch(data)];
end
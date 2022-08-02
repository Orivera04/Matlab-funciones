function nodes=filterbytype(P,TP)
%FILTERBYTYPE Filter out nodes from project using type object
%
%  NODES = FILTERBYTYPE(P,TP) returns a cell array of node objects that are
%  direct children of the project and match the specified type, TP.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.2.3 $  $Date: 2004/02/09 08:28:07 $


nodes = children(P);

if ~isempty(nodes)
    nodes = info(TP.filterlist(nodes));
    if length(nodes)==1
        nodes={nodes};
    end
else
    nodes = {};
end
function [obj, nd] = addexprtoproject(obj, data)
%ADDEXPRTOPROJECT Add multiple expression pointers to the project
%
%  [OBJ, NEWNODES] = ADDEXPRTOPROJECT(OBJ, DATA) creates a cgnode for every pointer in
%  the pointer vector DATA and adds them to the project.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.1 $    $Date: 2004/04/04 03:33:32 $ 

nd = null(xregpointer, size(data));
dataObj = infoarray(data);
for n = 1:length(data)
    node = cgnode(dataObj{n}, [], data(n), 1);
    if ~isempty(node)
        nd(n) = node;
    end
end

% Filter out any null nodes.  These occur if any of the expressions do not
% support creating a cgnode.
nd = nd(~isnull(nd));

% pass call to nodes adding interface
obj = addnodestoproject(obj, nd);

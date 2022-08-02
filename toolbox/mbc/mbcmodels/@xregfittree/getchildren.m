function [children, child2] = getchildren( Tree, parent )
%XREGFITTREE/GETCHILDREN Get the children of a given parent
%  CHILDREN = GETCHILDREN(T,PARENT) returns the child panela of the given 
%  PARENT panel.
%  [CHILD1,CHILD2] = GETCHILDREN(T,PARENT) 
%
%  See also XREGFITTREE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.6.1 $ 


if nargout > 1,
    children = Tree.Children(parent,1);
    child2   = Tree.Children(parent,2);
else
    children = Tree.Children(parent,:);
end

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|


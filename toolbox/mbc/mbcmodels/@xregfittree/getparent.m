function parent = getparent( Tree, child )
%XREGFITTREE/GETPARENT Get the parent of a given child
%  GETPARENT(T,CHILD) returns the parent panel of the given CHILD panel 
%
%  See also XREGFITTREE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.6.1 $ 

parent = Tree.Parent(child);

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|


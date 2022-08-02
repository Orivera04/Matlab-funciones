function T= AddChild(T,NewChild);
% MCTREE/ADDCHILD add child to tree.
%
% T= AddChild(T,NewChild)
% NewChild could be a tree object or a pointer to a tree.
% The static copy of the tree is returned, but this is not usually needed as 
% the updated tree is stored dynamically

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 06:47:29 $




NewChild= info(NewChild);

% sets NewChild's parent to be T
NewChild.Parent= T.node;

% get pointer to NewChild and append to T.Children
p= pointer(NewChild);

T.Children= [T.Children p];

% updates dynamic copy of T
T.node.info= T;

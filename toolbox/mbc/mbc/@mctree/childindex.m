function ind= ChildIndex(T);
% MCTREE/CHILDINDEX index from parent's child list
%
% ind= ChildIndex(T)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 06:47:37 $



if T.Parent~=0
   ch= T.Parent.children;
   ind= find(T.node==ch);
else
   ind=0;
end
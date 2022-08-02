function r=root(T)
% MCTREE/ROOT pointer to root of tree
% 
% p= root(T) or pointer function r= p.root;

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 06:48:05 $



r=T.node;
p=T.Parent;
while p~=0;
   r=p;
   T= info(p);
   p= T.Parent;
end
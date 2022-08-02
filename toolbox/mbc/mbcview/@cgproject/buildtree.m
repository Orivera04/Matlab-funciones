function buildtree(T,Tree,IL,tpfilter, MaxLvls, altparent)
%BUILDTREE   Create nodes in activex tree
%
%  buildtree(node, AXtree, IL,tpfilter, MaxLvls, altparent)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:28:03 $

% This is an overloaded method for the project
% The project node never appears but does always add
% it's children.


T=address(T);
if nargin<5
   MaxLvls=1;
end
if nargin<4
   tpfilter=cgtools.cgbasetype;
end

% pass on call to children
ch=T.children;
for n=1:length(ch)
   buildtree(ch(n).info,Tree,IL,tpfilter,MaxLvls,xregpointer);   
end

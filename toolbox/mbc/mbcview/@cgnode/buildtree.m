function buildtree(T,Tree,IL,tpfilter, MaxLvls, Pn)
%BUILDTREE   Create nodes in activex tree
%
%  buildtree(node, AXtree, IL, tpfilter, MaxLvls, altparent)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:24:42 $

% This is the default function for recursively addding nodes.  It
% may be overloaded by node sub-classes to customise what appears.

T=address(T);
if nargin<6
   Pn=T.Parent;
end
if nargin<5
   MaxLvls=1;
end
if nargin<4
   tpfilter=cgtools.cgbasetype;
end

nodes=Tree.nodes;
if matchtype(T.typeobject,tpfilter)
   % add self and pass on call to children
   T.addtotreeview(nodes,IL,MaxLvls,Pn);
   ch=T.children;
   for n=1:length(ch)
      buildtree(ch(n).info,Tree,IL,tpfilter, MaxLvls-1);   
   end
end


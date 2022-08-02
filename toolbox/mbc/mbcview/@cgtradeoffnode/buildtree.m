function buildtree(T,Tree,IL,tpfilter, MaxLvls, Pn)
%BUILDTREE Create nodes in activex tree
%
%  BUILDTREE(node, AXtree, IL, tpfilter, MaxLvls, altparent)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.4 $  $Date: 2004/02/09 08:37:12 $

% Overloaded adding for tradeoffs.  Trade Off nodes add all tables that
% are attached beneath them, ie the typefilter is dropped at this level

if nargin<6
    Pn = Parent(T);
end
if nargin<5
    MaxLvls = 1;
end
if nargin<4
    tpfilter = cgtools.cgbasetype;
end

nodes = Tree.nodes;
if matchtype(typeobject(T),tpfilter)
    % Add self as the setup node and as an output list node
    addtotreeview(T, nodes, IL, MaxLvls, Pn);
    
    % Add table nodes
    ch = children(T);
    for n=1:length(ch)
        buildtree(ch(n).info, Tree, IL, cgtools.cgbasetype, MaxLvls-1);
    end
end

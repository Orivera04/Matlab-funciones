function T=detach(T);
% MCTREE/DETACH detaches tree node from its parent and children.
%
% T=detach(T);
%  Note this function will return a static copy of the tree node. It is intended to be
%  used as a means of copying a node.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 06:47:42 $



T.node=xregpointer;
T.Children=[];
T.Parent=xregpointer;
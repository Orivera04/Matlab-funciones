function newchild = makechildren( root, OpenDialog )
%MAKECHILDREN Make children for this boundary node
%
%  C = MAKECHILDREN(R) is a empty matrix as by default boundary nodes
%  cannot have children in the tree. 
%  
%  See also: XREGBDRYROOT/MAKECHILDREN.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:13:19 $ 

% By default, all xregbdrynode types are unable to have children.
newchild = [];

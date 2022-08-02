function newchild = makechildren( root, OpenDialog )
%MAKECHILDREN Make children for this boundary root node
%
%  C = MAKECHILDREN(R) is a boundary node object that can be attached to
%  the boundary root node R as a child of R.
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:12:54 $ 


% Check inputs
if nargin < 2,
    OpenDialog = 0;
end

switch root.Stages,
    case 0, % Response Node
        newchild = xregbdrydev( uniquename( root, 'R_Boundary' ) );
    case 1, % Local Node
        newchild = xregtwostagebdrydev( uniquename( root, 'L_Boundary' ) );
    case 2, % Global Node
        newchild = xregbdrydev( uniquename( root, 'G_Boundary' ) );
end

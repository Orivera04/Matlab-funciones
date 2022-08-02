function newchild = makechildren( root, OpenDialog )
%MAKECHILDREN Make children for this boundary root node
%
%  C = MAKECHILDREN(R) is a boundary node object that can be attached to
%  the boundary root node R as a child of R.
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.3 $    $Date: 2004/02/09 08:13:34 $ 

%     makechildren( root )
%         If NumStages == 2, then this method compares the type of model
%         in the new child versus the types in the existing children. If
%         that type already exists, then the new child is not added.
%         cf modeldev/makechildren

% Check inputs
if nargin < 2,
    OpenDialog = 0;
end

switch root.NumStages,
    case 1,
        newchild = xregbdrydev( uniquename( root, 'Boundary' ) );
        
    case 2,
        childstages = children( root, 'getstages' );
        childstages = [ childstages{:} ];
        newstages = setdiff( [0, 1, 2], childstages );
        if isempty( newstages ),
            newchild = [];
        else,
            switch newstages(1),
                case 0,
                    name = 'Response';
                case 1,
                    name = 'Local';
                case 2,
                    name = 'Global';
            end
            newchild = xregbdrybranch( name, 'Stages', newstages(1) );
        end
end

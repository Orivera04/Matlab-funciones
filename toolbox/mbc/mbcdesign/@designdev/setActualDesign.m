function D = setActualDesign(D,NewDes,Stage)
%SETACTUALDESIGN Set new Actual Design
%
%  D = SETACTUALDESIGN(D, des, Stage) sets a new Actual Design into the
%  designdev object at the specified stage.  If there is already a design
%  called "Actual Design" it will be replaced, otherwise a new design will
%  be created.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $    $Date: 2004/02/09 07:04:07 $ 

if nargin<3
    Stage = length(D);
end

% get correct level designdev
Dcell = DesignDev2Cell(D);
D = Dcell{Stage};

flag = false(size(D.DesignTree.parents));
for i = 1:length(flag);
    % search through design list
    des = D.DesignTree.designs{i};
    flag(i) = strcmp(name(des),'Actual Design');
end

index = find(flag);
if isempty(index)
    % add a new design based on best
    D.DesignTree.parents = [D.DesignTree.parents 1];
    index = length( D.DesignTree.parents );
    % Make sure new design is unlocked
    NewDes = setlock(NewDes, false);
else
    % Pick up locked status from current design
    NewDes = setlock(NewDes, getlock(D.DesignTree.designs{index}));
end

% assign actual design
NewDes = name(NewDes,'Actual Design');
D.DesignTree.designs{index} = NewDes;

% convert back into nested designdev
Dcell{Stage} = D;
D = Cell2DesignDev(Dcell);

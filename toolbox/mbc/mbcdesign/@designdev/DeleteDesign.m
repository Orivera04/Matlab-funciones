function D = DeleteDesign(D,index)
%DELETEDESIGN Remove a design from the design tree
%
%  D = DeleteDesign(D,index) removes the design at index from the tree.  
%  If the design was a parent of other designs, these children are
%  reparented to the parent of the design that is being deleted.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $  $Date: 2004/02/09 07:02:52 $

dtree = D.DesignTree;

% Save the parent of the design being removed for later use
superParent = dtree.parents(index);

% Remove design
dtree.designs(index) = [];
dtree.parents(index) = [];

% Fix tree linkages for designs that are later in the lists of designs 
dtree.parents(dtree.parents>index) = dtree.parents(dtree.parents>index) - 1;

% Reparent designs that were children of the deleted design
dtree.parents(dtree.parents==index) = superParent;


if dtree.chosen== index 
    % Unselect best design
    dtree.chosen = 1;
elseif dtree.chosen>index
    % Chosen index decreases by one because the list of designs has been 
    % shortened
    dtree.chosen = dtree.chosen - 1;
end
D.DesignTree = dtree;


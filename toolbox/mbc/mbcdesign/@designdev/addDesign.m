function D = addDesign(D,des,Stage);
%DESIGNDEV/ADDDESIGN
%
% D = addDesign(D,des,Stage);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 07:02:57 $ 

if nargin<3
    Stage = length(D);
end
% get correct level designdev
Dcell= DesignDev2Cell(D);
D= Dcell{Stage};


% add to design tree
D.DesignTree.designs = [D.DesignTree.designs, {des}];
D.DesignTree.parents = [D.DesignTree.parents, 1];

Dcell{Stage} = D;
D = Cell2DesignDev(Dcell);

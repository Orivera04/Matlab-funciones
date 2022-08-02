function D = setBestDesign(D,ind,Stage);
%DESIGNDEV/SETBESTDESIGN
%
% [des,index] = setBestDesign(D,Stage);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:04:08 $ 

if nargin<3
    Stage= length(D);
end

% get correct level designdev
Dcell= DesignDev2Cell(D);
D= Dcell{Stage};


if ind==fix(ind) && ind>0 && ind<= length(D.DesignTree.parents)
    D.DesignTree.chosen= ind;
    Dcell{Stage}= D;
    D= Cell2DesignDev(Dcell);
end




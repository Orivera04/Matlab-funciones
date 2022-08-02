function [des,index] = ActualDesign(D,Stage);
%DESIGNDEV/ACTUALDESIGN
%
% [des,index] = ActualDesign(D,Stage);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 07:02:51 $ 

if nargin<2
    Stage= length(D);
end

% get correct level designdev
Dcell= DesignDev2Cell(D);
D= Dcell{Stage};

flag= false(size(D.DesignTree.parents));
for i= 1:length(flag);
    % search through design list
    des= D.DesignTree.designs{i};
    flag(i)= strcmp(name(des),'Actual Design');			
end

index= find(flag);
if length(index)~=1
    % use best design (or root)
    index= D.DesignTree.chosen;
end
des= D.DesignTree.designs{index};

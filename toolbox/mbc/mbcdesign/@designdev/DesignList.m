function [dlist,index] = DesignList(D,Stage);
%DESIGNDEV/DESIGNLIST
%
% [dlist,index] = DesignList(D,Stage);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 07:02:53 $ 

if nargin<2
    Stage= length(D);
end

% extract correct level
Dcell= DesignDev2Cell(D);
D= Dcell{Stage};

% get tree and extract list
dtree= D.DesignTree;
dlist= dtree.designs;
index=  dtree.chosen;

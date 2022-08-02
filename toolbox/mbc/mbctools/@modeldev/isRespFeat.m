function rf= isRespFeat(mdev);
%ISRESPFEAT True if modeldev object represents a response feature model

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.4 $  $Date: 2004/04/04 03:31:54 $

p= Parent(mdev);
while p~=0 & ~isa(p.model,'localmod')
    % go up the tree until you reach the top (p=0)
    % or you find a localmod
    p = p.Parent;
end

% true if you haven't reached the top
rf=  p~=0;

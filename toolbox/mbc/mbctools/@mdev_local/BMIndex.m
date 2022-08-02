function ind= BMIndex(mdev);
%BMINDEX

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:03:54 $

ind= BestModel(mdev.modeldev);
if ~isa(ind,'double')
   ind=0;
end


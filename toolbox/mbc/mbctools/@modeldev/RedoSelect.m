function mdev = RedoSelect(mdev,bm)
% REDOSELECT
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.1.6.1 $  $Date: 2004/02/09 08:09:48 $

pall = postorder(mdevtestplan(mdev),'address');
pall = [pall{:}];
ind = find(pall==address(mdev));

if bm{ind}~=0 & numChildren(mdev)
   mdev = BestModel(mdev,bm{ind},0);
end

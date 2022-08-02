function mdev = RedoSelect(mdev,bm)
% REDOSELECT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.1 $  $Date: 2004/02/09 08:04:07 $

pall = postorder(mdevtestplan(mdev),'address');
pall = [pall{:}];
ind = find(pall==address(mdev));

ind = bm{ind};

if ind~=0
    % remake twostage model
    TS = twostage(mdev,mdev.ResponseFeatures(ind,:));
    mdev = info(mdev);
    if ~isempty(mdev.TwoStage);
        [BMIndex,Table] = validate(mdev);
        mdev = info(mdev);
        mdev = BestModel(mdev,1,0);
    end
end

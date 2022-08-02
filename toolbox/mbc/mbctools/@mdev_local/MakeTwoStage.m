function OK= MakeTwoStage(mdev,MLE,varargin)
%MAKETWOSTAGE build two-stage model and select best
%
%  mdev = MAKETWOSTAGE(mdev)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $  $Date: 2004/04/04 03:31:10 $

switch BMindex(mdev)
    case 0
        L= model(mdev);
        TSModels= twostage(mdev,SelectRF(L));

        [BMIndex,Table]= validate(info(mdev));
        if ~isempty(BMIndex)
            % select best two-stage model
            BestModel(info(mdev),BMIndex);
            CompressStats(info(mdev));
            OK= true;
        else
            OK= false;
        end
    case 1
        OK= true;
    case 2
        OK= true;
        if nargin>1 && ~MLE
            [mdev,msg]= mle_best(mdev,0);
            mdev= makemlerf(mdev);
        else
            return
        end
end

mdev= info(mdev);
if OK && (nargin<2 || MLE)
    % run MLE
    mdev= runmle(mdev,varargin{:});
end

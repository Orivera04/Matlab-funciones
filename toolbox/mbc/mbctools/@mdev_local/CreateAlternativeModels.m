function mdev= CreateAlternativeModels(mdev,varargin);
%CreateAlternativeModels make a series of alternative models and select the best
%
% This option makes alternative response feature models for each response
% feature
%   mdev= CreateAlternativeModels(mdev,Models,Criteria);
%     Models   list of  models (from model template)
%     Criteria Selection criteria for best model
%
% This option makes alternative local models as well as alternative
% response feature models
%   mdev= CreateAlternativeModels(mdev,LocalModels,LocalCriteria,GlobalModels,GlobalCriteria);
%     LocalModels    list of local models
%     LocalCriteria  'Two-Stage RMSE'
%     GlobalModels   list of global models (from model template)
%     GlobalCriteria Selection criteria for best model
%


%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $  $Date: 2004/04/04 03:31:07 $


if length(varargin)==4
    
    % use global list for current local model
    children(mdev,'CreateAlternativeModels',varargin{3:4});    
    MakeTwoStage(info(mdev));
    
    presp= Parent(mdev);
    presp.CreateAlternativeModels(varargin{:});
else
    % just use global mlist
    children(mdev,'CreateAlternativeModels',varargin{:});    
    
    MakeTwoStage(info(mdev));
end

mdev= info(mdev);

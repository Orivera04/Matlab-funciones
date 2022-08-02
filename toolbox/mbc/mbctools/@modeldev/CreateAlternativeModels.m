function mdev= CreateAlternativeModels(mdev,mlist,Criteria,GList,Gcrit)
%CREATEALTERNATIVEMODELS Make a series of alternative models and select the best
%
%   mdev= CREATEALTERNATIVEMODELS(mdev,Models,Criteria);
%    Models   list of  models (from model template)
%    Criteria Selection criteria for best model
%
% This option is only available for the two-stage response node
%   mdev= CreateAlternativeModels(mdev,LocalModels,LocalCriteria,GlobalModels,GlobalCriteria);
%    LocalModels    list of local models
%    LocalCriteria  'Two-Stage RMSE'
%    GlobalModels   list of global models (from model template)
%    GlobalCriteria Selection criteria for best model

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $  $Date: 2004/02/09 08:09:29 $

m= model(mdev);

if isa(m,'xregtwostage');
    % Make up a series of two-stage models

    % use the default global model
    G= model( mdevtestplan(mdev) );
    if nargin<5
        % don't try any alternativesglobal models
        GList= {};
    end
    Lbase= get(mdev.Model,'local');
    DatumType= get(Lbase,'DatumType');
    for i= 1:length(mlist)
        % mlist is a list of localmods
        L= mlist{i};
        L= copymodel(Lbase,L);
        set(L,'DatumType',DatumType);
        TS= xregtwostage(L,G);
        mdev.Model= TS;
        NewL= makechildren(mdev);
        if ~isempty(GList)
            % build alternative global models
            NewL.children('CreateAlternativeModels',GList,Gcrit);
        end
        NewL.MakeTwoStage;
        mdev= info(mdev);
    end
    OK= ChooseBest(mdev,'Two-Stage RMSE');
    mdev= info(mdev);
else
    if nargin>3
        error('mbc:modeldev:InvalidArgument','Invalid alternative models for response');
    end

    % one-stage or global models
    if ~isempty(mlist)
        % build alternative models for all response features
        % mlist from model template
        OK= buildmodels(mdev,mlist,Criteria);
    end
    mdev= info(mdev);
end
function mdev= RemoveOutliers(mdev,SelectionCriteria)
%RemoveOutliers Refit models after removing outliers 
%
%mdev= RemoveOutliers(mdev,SelectionCriteria);
% Inputs
%   SelectionCriteria  outlier selection rule or indices of points to 
%                      remove
% 
% Indices= func(model, data, factorName); 
%   The factors are the same as appear in the scatter plot in the model
%   browser. 
%   'data' contains the factors as columns of a matrix
%   'factorNames' is a cell array of the names for each factor

% Note it is also possible to use a specical array to do standard types of
% outlier removal (available from popmenus in model browser dialog). This
% option is not documented because of its complexity

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $  $Date: 2004/02/09 08:09:49 $

m= model(mdev);
OutlierIndices= [];
if nargin>=2 
    if ischar(SelectionCriteria) ||  iscell(SelectionCriteria);
        if iscell(SelectionCriteria)
            SelectionCriteria=SelectionCriteria{1};
        end
        set(m,'outliers',SelectionCriteria);
        mdev= model(mdev,m);
    else
        % outlier indices specified
        OutlierIndices= SelectionCriteria;
        if islogical(OutlierIndices)
            OutlierIndices= find(OutlierIndices);
        end
    end
end
if isempty( get(m,'outliers') );
    set(m,'outliers',DefaultOutliers(m));
    mdev= model(mdev,m);
end

if isempty(OutlierIndices)
    % rule-based outlier selection
    [X,Y,DataOK]= FitData(mdev);
    [data,factors,standardPlotStr,NewOutliers]= diagnosticStats(mdev);
    DataIndex = find(DataOK);
    OutlierIndices= DataIndex(NewOutliers);
else
    X= getdata(mdev);
    % outlier indices specified
    if min(OutlierIndices)<1 || max(OutlierIndices)>size(X,1);
        error('mbc:modeldev:InvalidIndex','Invalid outlier point(s)')
    end
    NewOutliers= OutlierIndices(:);
end

if ~isempty(NewOutliers)
    NewOutliers= unique([outliers(mdev) ;  OutlierIndices]);
    % set outliers
    preorder(mdev,'outliers',NewOutliers);
    % refit all models
    preorder(info(mdev),'refit');
end
mdev= info(mdev);

    
    
    
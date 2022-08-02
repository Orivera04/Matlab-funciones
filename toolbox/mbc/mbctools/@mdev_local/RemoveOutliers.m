function mdev = RemoveOutliers(mdev, LocalSelectionCriteria,GlobalSelectionCriteria)
%REMOVEOUTLIERS Refit models after removing outliers 
%
%  mdev = REMOVEOUTLIERS(mdev,LocalSelCriteria,GlobalSelCriteria) applies
%  the selected outliers and then refits all local models and response
%  features.
%
%  Inputs:
%    LocalSelectionCriteria  - Local outlier selection rule or indices
%    GlobalSelectionCriteria - Global outlier selection rule or indices
%
%  Selection rules are implemented by providing a handle to a function
%  with the interface:
%
%    Indices = func(model, data, factorName)
%
%  The factors are the same as they appear in the scatter plot in the model
%  browser.  'data' contains the factors as columns of a matrix.
%  'factorNames' is a cell array of the names for each factor.
%
%  See also MDEV_LOCAL/REMOVEOUTLIERSFORTEST, MODELDEV/REMOVEOUTLIERS.

% Note it is also possible to use a specical array to do standard types of
% outlier removal (available from popmenus in model browser dialog). This
% option is not documented because of its complexity

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $  $Date: 2004/02/09 08:04:08 $


L= model(mdev);

OutlierIndices= [];
if nargin>=2
    if ischar(LocalSelectionCriteria) ||  iscell(LocalSelectionCriteria);
        if iscell(LocalSelectionCriteria)
            LocalSelectionCriteria=LocalSelectionCriteria{1};
        end
        
        set(L,'outliers',LocalSelectionCriteria);
        mdev= model(mdev,L);
    else
        % outlier indices specified
        OutlierIndices= LocalSelectionCriteria;
        if islogical(OutlierIndices)
            OutlierIndices= find(OutlierIndices);
        end    
    end
end
if nargin < 3
    GlobalSelectionCriteria= [];
end
    
if isempty( get(L,'outliers') );
    set(L,'outliers',DefaultOutliers(L));
    mdev= model(mdev,L);
end

Yall = getdata(mdev);
Ns= size(Yall,3);
Nrec= size(Yall,1);
Spos   = tstart(Yall);
NewOutliers = [];

  
if ~isempty(OutlierIndices)
    % outlier indices specified
    
    if min(OutlierIndices)<1 || max(OutlierIndices)>Nrec;
        error('mbc:modeldev:InvalidIndex','Invalid outlier point(s)')
    end
    NewOutliers = OutlierIndices(:);    
    
else
    for SNo=1:Ns;
        % select outliers using rule
        
        [X,Y,DataOK]= FitData(mdev,SNo);
        DataIndex = find(DataOK);
            
        [data,factors,standardPlotStr,olIndex] = diagnosticStats(mdev,SNo);
        
        % build list of record indices
        RecInd= Spos(SNo) + DataIndex(olIndex)-1;
        NewOutliers = [ NewOutliers ; RecInd(:) ];    
    end
end

if ~isempty(NewOutliers)    
    % update outliers
    NewOutliers= unique([outliers(mdev) ;  NewOutliers]);
    mdev= info( outliers(mdev,NewOutliers) );
    
    % fit local models
    [OK,mdev]= fitmodel(mdev);
    % refit response features
    children(mdev,'refit');
    
    % remove outliers from response features
    children(mdev,'RemoveOutliers',GlobalSelectionCriteria);
    
end

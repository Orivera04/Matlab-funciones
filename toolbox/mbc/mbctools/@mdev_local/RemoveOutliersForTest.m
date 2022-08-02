function mdev = RemoveOutliersForTest(mdev,TestNumber, LocalSelectionCriteria,GlobalSelectionCriteria)
%REMOVEOUTLIERSFORTEST Refit models after removing outliers 
%
%  mdev = REMOVEOUTLIERSFORTEST(mdev,TestNumber,LocalSelCriteria,GlobalSelCriteria)
%  applies the selected outliers and then refits all local models and
%  response features.
%
%  Inputs
%    TestNumber              - Single test number to refit.
%    LocalSelectionCriteria  - Local outlier selection mfile
%    GlobalSelectionCriteria - Global outlier selection mfile
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
%  See also MDEV_LOCAL/REMOVEOUTLIERS, MODELDEV/REMOVEOUTLIERS.

% Note it is also possible to use a specical array to do standard types of
% outlier removal (available from popmenus in model browser dialog). This
% option is not documented because of its complexity

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $  $Date: 2004/02/09 08:04:09 $

L= model(mdev);


OutlierIndices= [];
if nargin>=3 
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
if nargin < 4
    GlobalSelectionCriteria= [];
end
    
if isempty( get(L,'outliers') );
    set(L,'outliers',DefaultOutliers(L));
    mdev= model(mdev,L);
end

Yall = getdata(mdev);
Ns= size(Yall,3);
Spos   = tstart(Yall);
NewOutliers = [];

if numel(TestNumber)~=1 || ~isnumeric(TestNumber) || TestNumber<1 || TestNumber>Ns
    error('mbc:mdev_local:InvalidIndex','Invalid test number')
end
    
if ~isempty(OutlierIndices)
    % outlier indices 
    
    if min(OutlierIndices)<1 || max(OutlierIndices)>size(Yall{TestNumber},1);
        error('mbc:mdev_local:InvalidIndex','Invalid outlier point(s)')
    end
    % build list of record indices
    RecInd= Spos(TestNumber) + OutlierIndices-1;
    NewOutliers = [ RecInd(:) ];    
    
else
    % select outliers using rule
    [X,Y,DataOK]= FitData(mdev,TestNumber);
    DataIndex = find(DataOK);
    
    [data,factors,standardPlotStr,olIndex] = diagnosticStats(mdev,TestNumber);
    
    % build list of record indices
    RecInd= Spos(TestNumber) + DataIndex(olIndex)-1;
    NewOutliers = [ NewOutliers ; RecInd(:) ];    
end

if ~isempty(NewOutliers)    
    % update outliers
    NewOutliers= unique([outliers(mdev) ;  NewOutliers]);
    mdev= info( outliers(mdev,NewOutliers) );
    
    % fit local model
    if isempty(covmodel(L))
        [OK,mdev]= fitmodel(mdev,TestNumber);
    else
        [OK,mdev]= fitmodel(mdev);
    end
    % refit response features
    children(mdev,'refit');
    
    % remove outliers from response features
    children(mdev,'RemoveOutliers',GlobalSelectionCriteria);
end
   
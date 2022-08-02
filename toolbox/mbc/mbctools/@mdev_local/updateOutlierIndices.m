function mdev= updateOutlierIndices(mdev,NewData,OldData);
%UPDATEOUTLIERINDICES 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.3 $  $Date: 2004/02/09 08:05:19 $

% sweep guids are based on data used for fitting this local node
if nargin<2
    [X,NewData]= getdata(mdev);
    [Xc,Yc,OK,BadData]=checkdata(model(mdev),X,NewData);
    NewData(BadData)= NaN;
end
NewGUIDList=  getSweepGuids(NewData, 'goodonly');

if nargin<3
    % response features
    OldData= mdev.RFData.info;
end
OldGUIDList= getGuids(OldData);

% now update outlier indices for response features
ptrs2Update= preorder(mdev,@address);
if iscell(ptrs2Update)
    ptrs2Update= [ptrs2Update{2:end}];
else
    ptrs2Update= ptrs2Update(2:end);
end
outlierInds= pveceval(ptrs2Update,@rfoutliers);

if ~all(cellfun('isempty',outlierInds))
    for i=1:length(outlierInds)
        % find new indices
        NewInd= NewGUIDList(OldGUIDList(outlierInds{i}));
        % an index of 0 indicates that the guid isn't in the new list
        outlierInds{i} = NewInd(NewInd~=0);
    end
    % update outlier indices
    out= pvecinputeval(ptrs2Update,@rfoutliers,outlierInds);
end

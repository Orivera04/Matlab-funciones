function TP= updateOutlierIndices(TP,NewData,OldData);
%MDEVTESTPLAN/UPDATEOUTLIERINDICES

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
% $Revision: 1.7.6.2 $  $Date: 2004/02/09 08:08:24 $

if IsMatched(TP)
    if nargin<2
        NewData= TP.DataLink.info;
    end
    if nargin<3
        % Y data not yet updated
        OldData= getdata(TP,'Y');
    end
    NewGUIDList= getGuids(NewData);
    OldGUIDList= getGuids(OldData);    
    
    if numstages(TP)==1
        % for one-stage models need to update all model nodes below testplan
        ptrs2Update= preorder(TP,@address);
        if length(ptrs2Update)>1
            % remove testplan pointer
            ptrs2Update= [ptrs2Update{2:end}];
        else
            ptrs2Update= null(xregpointer,1,0);
        end
    else
        % two-stage pointes = response + local nodes
        rptrs= children(TP);
        lptrs= pveceval(rptrs,@children);
        lptrs= [lptrs{:}];
        ptrs2Update= [rptrs lptrs];
    end
    
    % get all outlier indices
    outlierInds= pveceval(ptrs2Update,@outliers);
    
    for i=1:length(outlierInds)
        % find new indices based on guid arrays
        NewInd= NewGUIDList(OldGUIDList(outlierInds{i}));
        % an index of 0 indicates that the guid isn't in the new list
        outlierInds{i} = NewInd(NewInd~=0);
    end
    
    % update outlier indices
    out= pvecinputeval(ptrs2Update,@outliers,outlierInds);
    
    if  numstages(TP)>1 && ~isempty(lptrs) 
        % update pointer indices for new respons features
        out= pveceval(lptrs,@updateOutlierIndices);
    end
    
end

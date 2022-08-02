function ssf = addGuidFilter(ssf, guids)
%SWEEPSETFILTER/ADDGUIDFILTER adds guids to the list of removed records
%
%  SSF = ADDGUIDFILTER(SSF, GUID)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 08:08:29 $ 

% Add the new guids to filter out
ssf.filterGuid = unique(ssf.filterGuid, guids);
% Update the cache's without reevaluateing any filters
ssf = updateFilter(ssf, [], []);

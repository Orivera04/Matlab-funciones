function ssf = removeGuidFilter(ssf, guids)
%SWEEPSETFILTER/REMOVEGUIDFILTER removes guids from the list of removed records
%
%  SSF = REMOVEGUIDFILTER(SSF, GUID)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 08:12:04 $ 

% Add the new guids to filter out
ssf.filterGuid = ssf.filterGuid(~ismember(ssf.filterGuid, guids));
% Update the cache's without reevaluateing any filters
ssf = updateFilter(ssf, [], []);

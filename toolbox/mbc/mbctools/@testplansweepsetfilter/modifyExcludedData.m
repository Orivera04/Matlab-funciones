function obj = modifyExcludedData(obj, guidsToAdd, guidsToRemove)
%MODIFYEXCLUDEDDATA A short description of the function
%
%  OBJ = MODIFYEXCLUDEDDATA(OBJ, GUIDSTOADD, GUIDSTOREMOVE)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:11:23 $ 

% Get the sweepset that we point to
ss = sweepset(sweepsetfilter(obj));
% Have we been given an index or a guid array
if isnumeric(guidsToAdd)
    guidsToAdd = getSweepGuids(ss, guidsToAdd);
end
% Have we been given an index or a guid array
if isnumeric(guidsToRemove)
    guidsToRemove = getSweepGuids(ss, guidsToRemove);
end
% What was there before
previousExcludedData = obj.excludedData;
% Remove the guidsToRemove  from the excluded dta
obj.excludedData = setdiff(obj.excludedData, guidsToRemove);
% Add the new guidsToAdd to the list of excluded data
obj.excludedData = unique(obj.excludedData, guidsToAdd);
% Has anything changed
if ~isequal(previousExcludedData, obj.excludedData)
    % Tell the correct people that the tssf has changed
    obj = updateExcludedData(obj, ss);
    % Queue the relevent events
    queueEvent(obj, 'tssfExcludedDataChanged');
end
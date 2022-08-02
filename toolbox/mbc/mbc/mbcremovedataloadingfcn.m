function [OK] = mbcRemoveDataLoadingFcn(index)
%MBCREMOVEDATALOADINGFCN Remove a particular data loading function by index
%
%  OK = MBCREMOVEDATALOADINGFCN(INDEX) removes the data loading functions
%  defined in positions INDEX in the array of functions returned by
%  MBCGETDATALOADINGFCN
%  
%  Example usage:
%
%  OK = xregRemoveDataLoadingFcn([2 3 4]) removes the second, third and
%  fourth checked-in data loading functions.
%  
%  See also MBCMODEL, MBCGETDATALOADINGFCN, MBCCHECKINDATALOADINGFCN.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $    $Date: 2004/02/09 06:49:02 $ 

% Get current Data Loading preferences
p = getpref(mbcprefs('mbc'), 'DataLoading');
% How many checked in functions
numFunctions = length(p.DataImportFunctions);
% Check that all indices passed in are valid
if ~all(ismember(index, 1:numFunctions))
    error('mbc:mbctools:InvalidArgument', 'Matrix index is out of range for deletion');
end
% Remove the relevant functions
p.DataImportFunctions(index) = [];
% Get the current user preferences
currentPrefs = mbcprefs('mbc');
% Set the new loading functions
setpref(currentPrefs, 'DataLoading', p);
% And save them
saveprefs(currentPrefs);
% Return true
OK = true;
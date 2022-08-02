function f = mbcGetDataLoadingFcn
%MBCGETDATALOADINGFCN Get a list of checked in data loading functions
%
%  FCNS = MBCGETDATALOADINGFCN gets a structure array containing the
%  currently checked in data loading function options in the Model Browser.
%  The return array FCNS contains three fields
%   FCNS.function - the name of the function used to load that type of data
%   FCNS.filterSpec - the filter specification used during checkin
%   FCNS.fileType - the type name loaded by the function
%
%  Example usage:
%
%    fcns = mbcGetDataLoadingFcn

%  See also MBCMODEL, MBCCHECKINDATALOADINGFCN, MBCREMOVEDATALOADINGFCN

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 06:48:53 $ 

% Get current Data Loading preferences
p = getpref(mbcprefs('mbc'), 'DataLoading');
f = p.DataImportFunctions;
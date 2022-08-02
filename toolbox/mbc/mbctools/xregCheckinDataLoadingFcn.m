function OK = xregCheckinDataLoadingFcn(varargin)
%XREGCHECKINDATALOADINGFCN Add a data loading function to the Model Browser
%  XREGCHECKINDATALOADINGFCN has been replaced with MBCCHECKINDATALOADINGFCN.  
%  XREGCHECKINDATALOADINGFCN currently works but will be removed in the 
%  future.  Use MBCCHECKINDATALOADINGFCN instead.
%
%  OK = XREGCHECKINDATALOADINGFCN(FUNC, FILTERSPEC, FILETYPE) adds a new
%  data loading option to the Model Browser.  FUN is a string that is the
%  function to call to load the data.  FILTERSPEC is a (1x2) cell array
%  consisting of {FILEFILTER, DESCRIPTION}, e.g. {'*.m', 'M-files (*.m)'}.
%  FILETYPE is a string that fully describes the file format.
%
%  Example usage:
%
%    OK = xregCheckinDataLoadingFcn('loadmydata', ...
%          {'*.k', 'k-files (*.k)'},...
%          'My data loader (k-files)');
%
%  See also MBCMODEL, MBCGETDATALOADINGFCN, MBCREMOVEDATALOADINGFCN.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.8.4.3 $  $Date: 2004/02/09 08:20:57 $


warning('mbc:dataloading:DeprecatedFunction', 'xregcheckindataloadingfcn will be deprecated. Use mbccheckindataloadingfcn instead');
OK = mbccheckindataloadingfcn(varargin{:});
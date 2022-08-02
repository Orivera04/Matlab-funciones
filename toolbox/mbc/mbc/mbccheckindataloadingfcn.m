function OK = mbcCheckinDataLoadingFcn(fun, filterSpec, fileType, filename)
%MBCCHECKINDATALOADINGFCN Add a data loading function to the Model Browser
%
%  OK = MBCCHECKINDATALOADINGFCN(FUNC, FILTERSPEC, FILETYPE) adds a new
%  data loading option to the Model Browser.  FUN is a string that is the
%  function to call to load the data.  FILTERSPEC is a (1x2) cell array
%  consisting of {FILEFILTER, DESCRIPTION}, e.g. {'*.m', 'M-files (*.m)'}.
%  FILETYPE is a string that fully describes the file format.
%
%  Example usage:
%
%    OK = mbccheckindataloadingfcn('loadmydata', ...
%          {'*.k', 'k-files (*.k)'},...
%          'My data loader (k-files)');
%
%  See also MBCMODEL, MBCGETDATALOADINGFCN, MBCREMOVEDATALOADINGFCN.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.1.6.3 $  $Date: 2004/02/09 06:48:45 $



DO_FILE_LOAD_CHECK = nargin > 3;
OK = 0;
% Does fun exist on the MATLAB path
if isa(fun, 'function_handle')
    funStr = func2str(fun);
else
    funStr = fun;
end

if ~exist(funStr)
    error(['Function ' funStr ' not found on the MATLAB path']);
end

% Is filterSpec a 1 x 2 cell array of strings
if size(filterSpec) ~= [1 2] | ~iscell(filterSpec) | ~ischar(filterSpec{1}) | ~ischar(filterSpec{2})
    error('The filterSpec input must be a 1 x 2 cell array containing character arrays');
end

% Is fileType a character array
if ~ischar(fileType)
    error('The fileType input must be a character array');
end

if DO_FILE_LOAD_CHECK
    % Attempt to load file filename using the supplied function.
    % If it returns sucessfully then continue
    
    %%%% TO DO - Add load checking code
end

% Get current Data Loading preferences
p = getpref(mbcprefs('mbc'), 'DataLoading');
f = p.DataImportFunctions;

% Are we re-checking in a function prototype based on the filter spec or
% the file type?
ind = [];
for i = 1:length(f)
    if isequal(upper(filterSpec), upper(f(i).filterSpec)) | isequal(upper(fileType), upper(f(i).fileType))
        ind = i;
    end
end

if isempty(ind)
    ind = length(f) + 1;
end

f(ind).function = fun;
f(ind).filterSpec = filterSpec;
f(ind).fileType = fileType;

p.DataImportFunctions = f;
% Get the current user preferences
currentPrefs = mbcprefs('mbc');
% Set the new loading functions
setpref(currentPrefs, 'DataLoading', p);
% And save them
saveprefs(currentPrefs);

OK = 1;

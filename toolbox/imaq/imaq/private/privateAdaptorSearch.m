function [pathlist, vendorOrXML, errflag] = privateAdaptorSearch
%PRIVATEADAPTORSEARCH Locate image acquisition adaptors.
% 
%    [PATHS, VENDORS, ERR] = PRIVATEADAPTORSEARCH locates all available image 
%    acquisition adaptor files and returns the path to each in cell array 
%    PATHS. VENDORS is a cell array of the vendor name for each path 
%    returned. If an error occurs, an error flag is returned in ERR.
%
%    The sequence for locating adaptor related files are as follows:
%       1) Determine if the path to the adaptor files was provided.
%       2) Locate MathWorks supplied adaptors in the imaqadaptors directory.
%       3) Locate third-party adaptors in the imaqexternal directory.
%
%    PRIVATEADAPTORSEARCH is used internally by the toolbox engine. It is
%    not intended to be used directly by an end user.
%

%    CP 9-01-01
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:06:06 $

% Initialize variables.
pathlist = '';
vendorOrXML = '';
errflag = false;
if ispc
    osExt = '.dll';
    osDirType = 'win32';
else
    errflag = true;
    err.identifier = 'imaq:privateAdaptorSearch:invalidOS';
    err.message = privateMsgLookup(err.identifier);
    lasterror(err);
    return;
end

% Define the toolbox root location.
imaqRoot = which(['imaqmex' osExt], '-all');

% Define adaptor directory locations.
mwAdaptorDir = [fileparts(imaqRoot{1}) 'adaptors'];

% Initialize variable:
adaptorPaths = {};
vendorNames = {};
wildFile = ['*' osExt];

% Step (1):
% No adaptor provided as an input.

% Step (2):
% Start by performing a wildcard search (ex. *.dll)
% for any MathWorks adaptors.
tlbxSearchPath = fullfile(mwAdaptorDir, osDirType, wildFile);
searchPath = tlbxSearchPath;
dirList = dir(searchPath);
for i=1:length(dirList)
    adaptorFileName = dirList(i).name;
    % Make sure it's the correct extension. DIR returns files
    % like *.dllfoobar. Also make sure file is prepended with
    % 'mw':
    %       'mw' + vendor name + 'imaq' + '.dll'
    extLen = length(osExt);
    extCorrect = strcmp(adaptorFileName(end-extLen+1:end), osExt);
    prepended = strcmp(adaptorFileName(1:2), 'mw');
    appended = strcmp(adaptorFileName(end-extLen-3:end-extLen), 'imaq');
    if extCorrect && prepended && appended,
        rootVendorName = strrep(adaptorFileName, 'mw', '');
        rootVendorName = strrep(rootVendorName, ['imaq' osExt], '');
        adaptorPaths = {adaptorPaths{:} fullfile(mwAdaptorDir,...
            osDirType, adaptorFileName)};
        vendorNames = {vendorNames{:} rootVendorName};
    end
end

% Step (3):
% Check for externally registered adaptors.
try
    registeredAdaptors = privateGetSetUserPrefAdaptors;
catch
    lerror = lasterror;
    if (strcmp(lerror.identifier, 'MATLAB:javachk:featureNotAvailable'))
        registeredAdaptors = {};
        s = warning('off', 'backtrace');
        warning('imaq:imaqregister:nojvm', ...
            'No java support detected.  Third party adaptors will not be available.');
        warning(s);
    else
        rethrow(lerror)
    end
end
        
for i = 1:length(registeredAdaptors)
    [pathName adaptorName] = fileparts(registeredAdaptors{i});
    adaptorPaths = {adaptorPaths{:}, registeredAdaptors{i}};
    vendorNames = {vendorNames{:}, adaptorName};
end

% Use lower case names for adaptors.
vendorOrXML = lower(vendorNames);
pathlist = adaptorPaths;

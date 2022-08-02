function D = attachData(T, pSSF, varargin)
%MDEVTESTPLAN/ATTACHDATA select new data for test plan
%
% T= attachData(T,pSSF,Property,Value)
% Assume test plan set up with initial design and channel names
% 
% Inputs
%   T     mdevtestplan object
%   pSSF  pointer to sweepsetfilter
%   Property {'unmatcheddata','moredata','moredesign','tolerances'}
%   Value      Options   = {{'all', 'none'} , {'all', 'closest'} , {'none', 'closest'},1xNumInputs double};
%              Defaults  = {'none','closest','none',ModelRange/20};
% Outputs
%   T     mdevtestplan object

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

% $Revision: 1.1.8.3 $  $Date: 2004/04/04 03:31:32 $


if pSSF == T.DataLink
    % data already attached to testplan so nothing to do
    D = T.DataLink;
    return
end
% Do the factor names exist in the data set
if isempty( pSSF.find(factorNames(T.DesignDev)) )
    error('mbc:mdevtestplan:InvalidFactorNames','Factor names are not defined in dataset.') 
end
% Need the model range to set the default tolerances
[dummyLB, dummyUB, R] = range(model(T));
% Set the valid properties that could be sent in
validProps = {'unmatcheddata' 'moredata' 'moredesign' 'tolerances'};
validVals  = {{'all' 'none'}  {'all' 'closest'}  {'none' 'closest'} 'double'};
defaultVal = {'all' 'all' 'none' R/20};
Values = mbcCheckPropertyValuePairs(validProps, validVals, defaultVal, varargin{:});

% Looks like the input parameters are all valid so get on with the job of
% attaching data - errors should be unlikely between here and the end

% NOTE - If data is already attached to the testplan then the call to
% setupTSSF below will automatically unlink that data and link the new data
% in it's place

% Setup tssf for testplan using data set in location pSSF
T = setupTSSF(T, pSSF);
% Get the new tssf that has been created - note this might be a different
% pointer to pSSF.
tssf = T.DataLink.info;
% Set the default selection criteria and tolerances
tssf = set(tssf,...
    {'defaultSelectionUnmatchedData',...
        'defaultSelectionMoreData',...
        'defaultSelectionMoreDesign',...
        'defaultSelectionApply'},...
    [Values(1:3) {true}] ); 
tssf = setTolerance(tssf, Values{end});
% Call the clustering algorithm
tssf = runClusterAlgorithm(tssf);
% Apply the results of the clustering
tssf = applyClusterSettings(tssf);
% select data and make response models
T = modifyData(info(T), T.DataLink, tssf);
% Return pointer to data object
D = T.DataLink;
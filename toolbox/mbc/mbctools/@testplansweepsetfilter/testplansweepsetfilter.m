function obj = testplansweepsetfilter(pSweepset, testplan, actualDesign)
%TESTPLANSWEEPSETFILTER Constructor for testplansweepsetfilter object
%
%  OBJ = TESTPLANSWEEPSETFILTER
%      = TESTPLANSWEEPSETFILTER(pSWEEPSET)
%      = TESTPLANSWEEPSETFILTER(pSWEEPSET, TESTPLAN)
%      = TESTPLANSWEEPSETFILTER(pSWEEPSET, TESTPLAN, ACTUAL_DESIGN)
%      = TESTPLANSWEEPSETFILTER(SSF)
%      = TESTPLANSWEEPSETFILTER(SSF, TESTPLAN)
%      = TESTPLANSWEEPSETFILTER(SSF, TESTPLAN, ACTUAL_DESIGN)
%      = TESTPLANSWEEPSETFILTER(TSSF)
%      = TESTPLANSWEEPSETFILTER(TSSF, TESTPLAN)
%      = TESTPLANSWEEPSETFILTER(TSSF, TESTPLAN, ACTUAL_DESIGN)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.7.6.2 $    $Date: 2004/02/09 08:12:47 $ 

NO_SWEEPSET = nargin < 1;
HAS_TESTPLAN = nargin > 1;
HAS_ACTUAL_DESIGN = nargin > 2;

% Initialise correctly for zero argument constructor
if ~HAS_TESTPLAN
    testplan = mdevtestplan;
end
if ~HAS_ACTUAL_DESIGN
    actualDesign = ActualDesign(testplan);
end

if HAS_TESTPLAN & ~isa(testplan, 'mdevtestplan')
    error('mbc:testplansweepsetfilter:InvalidArgument', 'TestplanSweepsetFilter must be created with two input arguments, a data object and a Testplan');
end

if HAS_ACTUAL_DESIGN & ~isa(actualDesign, 'xregdesign')
    error('mbc:testplansweepsetfilter:InvalidArgument', 'The actual design input to testplansweepsetfilter must be an xregdesign object');
end

if NO_SWEEPSET
    ssf = sweepsetfilter;
elseif isa(pSweepset, 'testplansweepsetfilter')
    obj = pSweepset;    
    if HAS_TESTPLAN
        % Changing testplan of an existing tssf
        obj = i_updateTestplan(obj, testplan, actualDesign);
    end
    return
elseif isa(pSweepset, 'sweepsetfilter')
    ssf = pSweepset;
elseif isa(pSweepset, 'xregpointer')
    ssf = sweepsetfilter(pSweepset);
else
    error('mbc:testplansweepsetfilter:InvalidArgument', 'TestplanSweepsetFilter must be created with two input arguments, a data object and a Testplan');
end

% Information about the object fields
%------------------------------------------
% actualDesign = current on-the-fly design with selected data "nailed" into it
% excludedData = GUID array of the excluded data
% tolerance    = the tolerances used in clustering
% clusterAlg   = function handle to the clustering algorithm
% comment      = currently unused: notes field maybe useful one day!
% dataMessageService = event sending object to broadcast change information
% version      = crucial version info
% clusters     = struct describing the clusters with fields
%                data: [indices]
%                design: [indices]
%                status:
%                selecteddata: [indices]
%                selecteddesign: [indices]
% defaultSelection = struct describing default data/design selection
%                apply: [logical]
%                unmatcheddata: ['all','none']
%                moredata: ['all','closest']
%                moredesign: ['closest','none']
% cachedInfo   = struct adding additional infomation about the clusters
%                dataindesign: [indices]
%                designindata: [indices]
%                globaldata: [sweepset]
%                uncodeddesign: [xregdesign]
%                meandata: [array]

% NOTE THAT THE FIELDS ARE IN ALPHABETICAL ORDER !!!!!

obj.cachedInfo = struct(....
    'dataindesign', [],...
    'designindata', [],...
    'globaldata', [],...
    'uncodeddesign', [],...
    'meandata', []);

obj.clusterAlg = 'getClusters';

obj.clusters = struct(...
    'data', {},...
    'design', {},...
    'status', '',...
    'selecteddata', {},...
    'selecteddesign', {});

obj.codeddesign = actualDesign;

obj.defaultSelection = struct(...
    'apply', false,...
    'moredata', 'all',...
    'moredesign', 'none',...
    'unmatcheddata', 'all');

obj.excludedData = guidarray;
obj.ptestplan = address(testplan);
obj.tolerance = [];
obj.version = 1;


obj = class(obj, 'testplansweepsetfilter', ssf);

% And Update the cache
obj = updateCachedInfo(obj);
% Set some default tolerances
obj = i_setDefaultTolerance(obj);


%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function obj = i_setDefaultTolerance(obj);
%% put some values into the tolerance field using the underlying data
signals = globalsignalnames(obj);
%% do these names exist in the sweepset? If not we leave tolerance empty
if ~isempty(find(obj.sweepsetfilter, signals))
    mm = get(obj.sweepsetfilter(:,signals),{'min','max'});
    tol = ([mm{2}{:}] - [mm{1}{:}])./50;
else %% do we need this to avoid indexing failures later?
    tol = zeros(1, length(signals));
end
obj.tolerance = tol;

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function obj = i_updateTestplan(obj, testplan, actualDesign)
% Ensure the cluster info is reset
obj = emptyClusterInfoCache(obj);
% Update the testplan pointer and design
obj.ptestplan = address(testplan);
obj.codeddesign = actualDesign;
% And Update the cache
obj = updateCachedInfo(obj);
% Do we need to reset the tolerances?
if length(obj.tolerance) ~= size(obj.codeddesign, 2)
    % Set some default tolerances
    obj = i_setDefaultTolerance(obj);
end
% Queue an appropriate event
queueEvent(obj, 'tssfActualDesignChanged');

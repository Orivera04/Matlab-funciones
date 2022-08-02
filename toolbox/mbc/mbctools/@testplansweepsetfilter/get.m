function varargout = get(obj, Properties, varargin);
%TESTPLANSWEEPSETFILTER/GET

%  VALUES = GET(OBJ);
%  VALUES = GET(OBJ, PROPERTIES);
%  VALUES = GET(OBJ, PROPERTIES, INDEX);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.6.2 $    $Date: 2004/02/09 08:11:19 $ 

valid_props = {...
        'actualdesign',...1
        'actualdata',...2
        'clusters',...3
        'clusteralg',...4
        'tolerances',...5
        'matcheddesign',...6
        'unmatcheddesign',...7
        'matcheddata',...8
        'unmatcheddata',...9
        'excludeddata',...10
        'dataindesign',...11
        'designindata',...12
        'datanotindesign',...13
        'designnotindata',...14
        'matcheddesigninds',...15
        'unmatcheddesigninds',...16
        'matcheddatainds',...17
        'unmatcheddatainds',...18
        'excludeddatainds',...19
        'dataindesigninds',...20
        'designindatainds',...21
        'datanotindesigninds',...22
        'designnotindatainds',...23
        'numberdesignpoints',...24
        'numberdatapoints',...25
        'meandata',...26
        'codeddesign',...27
        'label',...28
    };

% Have we got any properties?
ALLPROPS = nargin < 2;
if ALLPROPS
    Properties = valid_props;
end

% Have we been given an index value
INDEXED = nargin > 2;

ISCHAR = ischar(Properties);
if ISCHAR
    Properties = {Properties};
end

values = cell(1,length(Properties));
Properties = lower(Properties);

for i = 1:length(Properties)
    property = Properties{i};
    mInd = strmatch(lower(property), valid_props, 'exact');
    if length(mInd) > 1
        error(['Ambiguous testplansweepsetfilter property: ' property]);
    end
    if isempty(mInd)
        % Are any properties to be got from the object being filtered
        values(i) = get(obj.sweepsetfilter, {property}, varargin{:});
    else	
        switch mInd
            case 1
                % actualdesign
                values{i} = obj.cachedInfo.uncodeddesign;
            case 2
                % actualdata
                values{i} = obj.cachedInfo.globaldata;
            case 3
                % clusters
                values{i} = obj.clusters;
            case 4
                % cluster algorithm
                values{i} = obj.clusterAlg;
            case 5
                % tolerances
                values{i} = obj.tolerance;
            case 6
                % matcheddesign
                matchedIndices = i_matchedDesignIndices(obj);
                values{i} = obj.cachedInfo.uncodeddesign(matchedIndices, :);
            case 7
                % unmatcheddesign
                unmatchedIndices = i_unmatchedDesignIndices(obj);
                values{i} = obj.cachedInfo.uncodeddesign(unmatchedIndices, :);
            case 8
                % matcheddata
                matchedIndices = i_matchedDataIndices(obj);
                values{i} = obj.cachedInfo.globaldata(:, :, matchedIndices);
            case 9
                % unmatcheddata
                unmatchedIndices = i_unmatchedDataIndices(obj);
                values{i} = obj.cachedInfo.globaldata(:, :, unmatchedIndices);
            case 10
                % excludeddata
                excludedIndices = i_excludedDataIndices(obj);
                values{i} = obj.cachedInfo.globaldata(:, :, excludedIndices);
            case 11
                % dataindesign
                values{i} = obj.cachedInfo.dataindesign;
            case 12
                % designindata
                values{i} = obj.cachedInfo.designindata;
            case 13
                % datanotindesign
                indices = setdiff(1:size(obj.cachedInfo.globaldata, 3), obj.cachedInfo.dataindesign);
                % Which points are not in design           
                values{i} = obj.cachedInfo.globaldata(:, :, indices);
            case 14
                % designnotindata                
                indices = setdiff(1:npoints(obj.codeddesign), obj.cachedInfo.designindata);
                % Which points are not in data   
                values{i} = obj.cachedInfo.uncodeddesign(indices, :);
            case 15
                % matcheddesigninds
                values{i} = i_matchedDesignIndices(obj);
            case 16
                % unmatcheddesigninds
                values{i} = i_unmatchedDesignIndices(obj);
            case 17
                % matcheddatainds
                values{i} = i_matchedDataIndices(obj);
            case 18
                % unmatcheddatainds
                values{i} = i_unmatchedDataIndices(obj);
            case 19
                % excludeddatainds
                values{i} = sort(i_excludedDataIndices(obj))';
            case 20
                % dataindesigninds
                values{i} = obj.cachedInfo.dataindesign;
            case 21
                % designindatainds
                values{i} = obj.cachedInfo.designindata;
            case 22
                % datanotindesigninds
                values{i} = setdiff(1:size(obj.cachedInfo.globaldata, 3), obj.cachedInfo.dataindesign);
            case 23
                % designnotindatainds
                values{i} = setdiff(1:npoints(obj.codeddesign), obj.cachedInfo.designindata);
            case 24
                % numberdesignpoints
                values{i} = npoints(obj.codeddesign);
            case 25
                % numberdatapoints
                values{i} = size(obj.cachedInfo.globaldata, 3);
            case 26
                % meandata
                values{i} = obj.cachedInfo.meandata;
            case 27
                % codeddesign
                values{i} = obj.codeddesign;
            case 28
                % label 
                values{i} = i_getLabel(obj);
        end
        if INDEXED 
            values{i} = values{i}(varargin{1});
        end
    end
end

if ALLPROPS
    varargout{1} = cell2struct(values, valid_props, 2);
elseif nargout == length(values)
    varargout = values;
else
    varargout{1} = values;
end
    



%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function matchedIndices = i_matchedDesignIndices(obj)
% SelectedDesign indices in 'designonly' clusters are not matched
status = {obj.clusters.status};
validClusters = ~(strcmp(status, 'designonly') | strcmp(status, 'unmatcheddesign'));
% Sort the output
matchedIndices = sort([obj.clusters(validClusters).selecteddesign]);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function unmatchedIndices = i_unmatchedDesignIndices(obj)
% Get the matched indicies
matchedIndices = i_matchedDesignIndices(obj);
% Get indices that aren't in the data
includedIndices = setdiff(1:npoints(obj.codeddesign), obj.cachedInfo.designindata);
% Find the difference
unmatchedIndices = setdiff(includedIndices, matchedIndices);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function matchedIndices = i_matchedDataIndices(obj)
% SelectedData indicies in 'dataonly' clusters are not matched
validClusters = ~strcmp({obj.clusters.status}, 'unmatcheddata');
% Sort the output
matchedIndices = sort([obj.clusters(validClusters).selecteddata]);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function unmatchedIndices = i_unmatchedDataIndices(obj)
% Get the matched indicies
matchedIndicies = i_matchedDataIndices(obj);
% Get the indicies of the included data
[dummy, includedIndices] = setdiff(getSweepGuids(obj.cachedInfo.globaldata), obj.excludedData);
% Remove all dataInDesign indices which are held in the dataindesign
includedIndices = setdiff(includedIndices, obj.cachedInfo.dataindesign);
% Find the all indicies not in the above two 
unmatchedIndices = setdiff(includedIndices, matchedIndicies);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function excludedIndices = i_excludedDataIndices(obj)
% Get the sweep guids of the global data
globalSweepGuids = getSweepGuids(obj.cachedInfo.globaldata);
% Find matches with the excluded data
excludedIndices = getIndices(globalSweepGuids, obj.excludedData);
% And remove any zeros
excludedIndices(excludedIndices == 0) = [];

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function label = i_getLabel(obj)
% Overloaded from ssf to append the name of the testplan to the ssf label
% Default testplan name
testplanName = '';
if isvalid(obj.ptestplan)
    testplanName = obj.ptestplan.name;
end
label = [testplanName ' : ' get(obj.sweepsetfilter, 'label')];
function obj = set(obj, Properties, Values);
%SET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.6.1 $  $Date: 2004/02/09 08:12:39 $

valid_props = {'clusteralg',...
        'label',...
        'defaultselectionapply',...
        'defaultselectionmoredata',...
        'defaultselectionmoredesign',...
        'defaultselectionunmatcheddata'};

% Have we got any properties?
ALLPROPS = nargin < 2;
if ALLPROPS
    obj = valid_props';
    return
end

ISCHAR = ischar(Properties);
if ISCHAR
    Properties = {Properties};
    Values = {Values};
end

for i = 1:length(Properties)
    property = lower(Properties{i});
    mInd = strmatch(property, valid_props);
    if length(mInd) > 1
        error(['Ambiguous testplansweepsetfilter property: ' property]);
    end
    if isempty(mInd)
        % Try calling the inherited set method
        obj.sweepsetfilter = set(obj.sweepsetfilter, {property}, Values(i));
    else
        switch mInd
            case 1
                % clusteralg
                obj.clusterAlg = Values{i};
            case 2
                % label
                obj = i_setLabel(obj, Values{i});
            case 3
                % defaultselectionapply
                obj.defaultSelection.apply = Values{i};
            case 4
                % defaultselectionmoredata
                if ~ismember(Values{i}, {'all', 'closest'})
                    error('mbc:testplansweepsetfilter:InvalidState', 'Invalid set state for tssf.');
                end
                obj.defaultSelection.moredata = Values{i};              
            case 5
                % defaultselectionmoredesign
                if ~ismember(Values{i}, {'none', 'closest'})
                    error('mbc:testplansweepsetfilter:InvalidState', 'Invalid set state for tssf.');
                end
                obj.defaultSelection.moredesign = Values{i};
            case 6
                % defaultselectionununmatcheddata
                if ~ismember(Values{i}, {'all', 'none'})
                    error('mbc:testplansweepsetfilter:InvalidState', 'Invalid set state for tssf.');
                end
                obj.defaultSelection.unmatcheddata = Values{i};
        end
    end
end


%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function obj = i_setLabel(obj, newLabel)
% Are the first elements of the name the same as the testplan name
if isvalid(obj.ptestplan)
    % Get the testplan prefix
    testplanPrefix = [obj.ptestplan.name ' : '];
    lengthPrefix = length(testplanPrefix);
    % Is the testplan prefix the beginning of the label
    if strncmp(testplanPrefix, newLabel, lengthPrefix)
        newLabel = newLabel(lengthPrefix+1:end);
    end
end
% Do the set
obj.sweepsetfilter = set(obj.sweepsetfilter, 'label', newLabel);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
% function obj = i_setClusters(obj, clusters)
% if ~iscell(clusters)
% 	error('Testplansweepsetfilter cluster property must be a cell array');
% end
% obj.clusters = clusters;
% % Tell everyone that the clusters have changed
% queueEvent(obj, 'tssfClustersChanged');

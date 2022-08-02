function factordata = getOppoint(optim, factornames, datasetname)
%GETOPPOINT Get operating points from a dataset
%
%  GETOPPOINT(optim, {'trq'})  gets trq data from default (first) dataset.
%  GETOPPOINT(optim, {'trq', 'rpm'})
%  GETOPPOINT(optim, {'trq'}, 'dataset10')  gets trq data from dataset10.
%  GETOPPOINT(optim, {'trq', 'rpm'}, 'dataset10')

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/04/04 03:26:10 $

% start : a few sanity checks
if isempty(optim.oppoints)
    error('mbc:cgoptim:InvalidState', ...
        'There are no oppoints to access in this optimization.');
end

if isempty(factornames)
    error('mbc:cgoptim:InvalidArgument', ...
        'No free variables have been specified.');
end

if ~iscell(factornames)
    error('mbc:cgoptim:InvalidArgument', ...
        'You must specify a cell array of factor names.');
end
% end : a few sanity checks

% now get the index to the requested (or default = 1) dataset
if nargin==2
    dsind = 1;
else
    dsind = find(strcmpi(datasetname, optim.oppointLabels));
    if isempty(dsind)
        error('mbc:cgoptim:InvalidValue', ...
            'Cannot find dataset %s in the optimization.', datasetname)
    end
end

% return the requested dataset
datasetptr = optim.oppoints(dsind);
opvallabels = optim.oppointValueLabels{dsind};
valuelabels = optim.valueLabels;

% sweep factornames along opvallabels and freevariables and get their pointers
valueptr = cell(1, length(factornames));
for i=1:length(factornames)
    opind = find(strcmp(factornames{i}, opvallabels));
    frind = find(strcmp(factornames{i}, valuelabels));
    if length(opind)==1
        valueptr{i} = optim.oppointValues{dsind}(opind);
    elseif length(frind)==1
        valueptr{i} = optim.values(frind);
    else
        error('mbc:cgoptim:InvalidValue', ...
            'Factor %s is not present in the dataset.', factornames{i});
    end
end

valuenames = cell(size(valueptr));
for i=1:length(valueptr)
    valuenames{i}= valueptr{i}.getname;
end
factordata = datasetptr.getdata(valuenames);

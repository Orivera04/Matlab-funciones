function optim = addoppointcolumns(optim, X, factornames, varargin)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 06:52:55 $

% Adds new columns of data to a data set in the optimization
% optim = addoppointcolumns(optim, X, factornames);
% optim = addoppointcolumns(optim, X, factornames, datasetname);
% X	:	Matrix of size NumberOfPointsInDataSet by NumberOfFactors
% factornames	:	Cell array of strings of factors that are in the columns of X (must be in the data set specified)
% datasetname	:	Name of the data set in the optimisation to add the columns to. The first data set in the optimisation is used if unspecified. 

if nargin > 3
    dataset_name = varargin{1};
    datasetLabels = optim.oppointLabels;
    dsind = find(strcmp(dataset_name, datasetLabels));
    if isempty(dsind)
        error('Unknown dataset.')
    else
        dsind = dsind(1);
    end    
else % just use the first dataset
    dsind = 1;
end

datasets  = optim.oppoints;
dataset = datasets(dsind); 

data = dataset.get('data');
if ~isequal(size(data,1), size(X,1))
    error('X must have the same number of rows as the dataset');
elseif ~isequal(length(factornames), size(X,2))
    error('X must have the same number of columns as the number of new factor names supplied');
elseif ~iscell(factornames)
   error('factornames should be supplied as a cell array of strings'); 
end  

existingfactors = dataset.get('factors');
for i =1:length(factornames)
    if ~ischar(factornames{i})
        error('factornames should be supplied as a cell array of strings');
    end
    if strcmp(factornames{i}, existingfactors)
        error(['Factor ' factornames{i} ' already exists in data set']);
    end    
    [dataset.info, fact_i]  = AddCage(dataset.info, factornames{i});
    dataset.info = dataset.set(fact_i,'data',X(:,i),'factor_type',2);
end

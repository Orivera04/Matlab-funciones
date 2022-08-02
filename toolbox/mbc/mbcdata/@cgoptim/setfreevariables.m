function optim = setfreevariables(optim, X, dataset_name)
%SETFREEVARIABLES Set new values for the output of free variables
%
%  OPTIM = SETFREEVARIABLES(OPTIM, X)  where X is a matrix of
%  data, size (Npoints in dataset) x (N free variables).  The optimization
%  object must have a dataset before this function is called.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.7.6.2 $    $Date: 2004/02/09 06:53:54 $

% Old calling syntax: you can specify a dataset, but it must be the primary
% one.  This argument is now deprecated.
if nargin > 2
    datasetLabels = optim.oppointLabels;
    if ~strcmp(dataset_name, datasetLabels{1})
        error('mbc:cgoptim:InvalidArgument', 'Can only set free variables in the primary operating point set.')
    end
end

pDatasets  = optim.oppoints;
pPrimeDataset = pDatasets(1); 
primeDataset = pPrimeDataset.info;

pFreeVars = optim.values;
indFreeVars = getFactorIndex(primeDataset, pFreeVars);

numberOfPoints = size(X,1);
numberOfFreeVar = size(X,2);
numberOfSolutions = size(X,3); 
%numberOfFactors = get(pPrimeDataset.info, 'numfactors');
primaryPtrs = get(primeDataset, 'ptrlist');
validst = isvalid(primaryPtrs);
validinds = find(validst);
numberOfFactors = length(validinds);

primaryData = get(primeDataset, 'data');
if (size(primaryData,1) ~= numberOfPoints)
    error('mbc:cgoptim:InvalidArgument', 'X must have the same number of rows as the primary dataset.');
elseif (length(indFreeVars) ~= numberOfFreeVar)
    error('mbc:cgoptim:InvalidArgument', 'X must have the same number of columns as there are free variables');
end

optim.outputData = zeros([numberOfPoints, numberOfFactors, numberOfSolutions]);
% Find inputs in the valid pointer list
bInputs = pveceval(primaryPtrs(validinds), 'isinport');
bInputs = [bInputs{:}];
indFixedValidVars = find(bInputs);
% Indices of inputs in data set ptrlist
bInputs = false(1, length(primaryPtrs));
bInputs(validinds(indFixedValidVars)) = true;
indFixedVars = find(bInputs);
% Indices of fixed variables in data set ptrlist
indFixedVars = setdiff(indFixedVars, indFreeVars);
% Indices of outputs, excluding unassigned data
indOutputs = setdiff(find(~bInputs), find(~isvalid(primaryPtrs)));
% Return fixed variable and output pointers
pFixedVars = primaryPtrs(indFixedVars);
pOutputs = primaryPtrs(indOutputs);
nOutputs = length(pOutputs);

% Indices of fixed variables, free variables and outputs in the list of
% valid pointers
indFixedValid = findptrs(pFixedVars, primaryPtrs(validinds));
indFreeValid = findptrs(pFreeVars, primaryPtrs(validinds));
indOutputValid = findptrs(pOutputs, primaryPtrs(validinds));

% Set up the fixed input variable values
passign(pFixedVars, pvecinputeval(pFixedVars, 'setvalue', num2cell(primaryData(:,indFixedVars) ,1)));

for k = 1:numberOfSolutions
    % Fixed variables
    optim.outputData(:,indFixedValid,k) = primaryData(:,indFixedVars);
    
    % Free variables
    optim.outputData(:,indFreeValid,k) = X(:, :, k);
    passign(pFreeVars, pvecinputeval(pFreeVars, 'setvalue', num2cell(X(:,:,k) ,1)));
    
    % Outputs
    for n = 1:nOutputs
        optim.outputData(:,indOutputValid(n),k) = evaluate(pOutputs(n).info);
    end
end
optim.outputColumns = primaryPtrs(validinds);

% Reinitialise weights
pObjectiveModels = pveceval(optim.objectiveFuncs, 'get', 'modptr');
optim.outputWeightsColumns = [pObjectiveModels{:}];
optim.outputWeights = ones(numberOfPoints, length(optim.outputWeightsColumns));
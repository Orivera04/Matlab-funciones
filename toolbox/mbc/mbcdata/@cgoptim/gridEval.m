function y = gridEval(optim, evalflag, columnptrs, X, varargin)
%GRIDEVAL
%
% y = gridEval(optim, columnptrs, X)
% y = gridEval(optim, columnptrs, X, datasetptr)
% y = gridEval(optim, columnptrs, X, datasetptr, rowind)
% evaluate columns of dataset at the freevariable values given by X

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.6.1 $    $Date: 2004/02/09 06:53:36 $



if nargin > 4
    datasetptr = varargin{1};
else
    datasetptr = optim.oppoints(1);
end

if nargin > 5
    rowind = varargin{2};
else
    rowind = [];
end

% set up the dataset 
oldranges = datasetptr.get('range');
ranges = oldranges;

data = datasetptr.get('data');

N = size(data,1); % this is the number of original dataset points
freevar = optim.values;

if ~isequal(length(freevar), size(X,2))
    error('Eval error: input matrix must have the same number of columns as there are free variables');
    return
end

% find the data set index to the free variables by pointer (not name)
varinds = getFactorIndex(info(datasetptr),freevar);

% make the right number of rows in the dataset
if ~isempty(freevar) & size(X,1)>1 
    gridflags = datasetptr.get('grid_flag');
    if any(gridflags(varinds) == 7)
        error('Eval error: one of the free variables is specified in the data set -- its values cannot be altered') 
    end
    ranges{varinds(1)} = [1:size(X,1)];
    datasetptr.info = datasetptr.set('range', ranges);
    datasetptr.info = datasetptr.range_grid;
end

repX = [];
for i = 1:size(X,1)
    repX = [repX; repmat(X(i,:), N, 1)];
end 

% get the re-gridded data
data = datasetptr.get('data');

% set the values of the free variables
data(:, varinds) = repX;

% determine all non-constant data dictionary inputs to the functions 
ptrs= pveceval(columnptrs,'getinports');
ddptrs = unique([ptrs{:}]);

% save the old values
saveval= pveceval(ddptrs,'getvalue');

% When we are gridding, we need to duplicate rowind so that we get each of the rows needed after
% range grid is applied
if ~isempty(rowind)
    newrowind = [];
    for j = 1:size(X,1)
        newrowind = [newrowind rowind+(j-1)*N];
    end
    rowind = newrowind;
end

% indices to the data dictionary inputs
dd_ind = getFactorIndex(info(datasetptr),ddptrs);
NewData= num2cell(data(rowind,dd_ind),1);
passign(ddptrs, pvecinputeval(ddptrs,'setvalue',NewData) );

try 
    switch evalflag
        case 'eval'
            y= pveceval(columnptrs,@i_eval);
        case 'pev'
            y= pveceval(columnptrs,@peveval);
    end
    y= cat(2,y{:});
catch
    % restore old values
    passign(ddptrs, pvecinputeval(ddptrs,'setvalue',saveval) );
    error('Problem evaluating an objective or constraint');
end

% restore old values
passign(ddptrs, pvecinputeval(ddptrs,'setvalue',saveval) );

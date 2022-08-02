function y = concatEval(optim, evalflag, columnptrs, X, varargin)
%CONCATEVAL
%
% y = concatEval(optim, columnptrs, X)
% y = concatEval(optim, columnptrs, X, datasetptr)
% y = concatEval(optim, columnptrs, X, datasetptr, rowind)
% evaluate columns of dataset at the freevariable values given by X

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.6.2 $    $Date: 2004/04/04 03:26:06 $

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

freevar = optim.values;    
if ~isequal(length(freevar), size(X,2))
    error('mbc:cgoptim:InvalidState', ...
        'Input matrix must have the same number of columns as there are free variables');
end
if size(X,1)~=length(rowind)
    error('mbc:cgoptim:InvalidState', ...
        ['The number of free variable values supplied does not match the ' ...
        'number of points in the data set to evaluate at.'])
end

% Find the data set index to the free variables by pointer (not name)
varinds = getFactorIndex(info(datasetptr),freevar);

% Determine all non-constant data dictionary inputs to the functions 
ptrs = pveceval(columnptrs,'getinports');
ddptrs = unique([ptrs{:}]);
dd_ind = getFactorIndex(info(datasetptr),ddptrs);

% Extract the subset of data that we want to base evaluation on
data = datasetptr.get('data');
InportData = data(rowind, dd_ind);

% Insert provided data for free variables.
[Needed, InportIndex] = ismember(varinds, dd_ind) ;
InportData(:, InportIndex(Needed)) = X(:, Needed);

% save the old values
saveval= pveceval(ddptrs,'getvalue');

% set up each input 
NewData = num2cell(InportData,1);
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

passign(ddptrs, pvecinputeval(ddptrs,'setvalue',saveval) );

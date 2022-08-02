function Y = evaluatesequential(obj, pSeq, dSeqNomValues, sQuant)
%EVALUATESEQUENTIAL Evaluate expression over each input
%
%  Y = EVALUATESEQUENTIAL(OBJ, SEQPTRS, SETPOINTS, QUANTITY) evaluates the
%  expression OBJ across each of the vector inputs listed in SEQPTRS in
%  sequence, while holding the rest of the inputs at a set value specified
%  by its entry in SETPOINTS.  The return value Y is a cell array the same
%  length as SEQPTRS containing the evaluation results as each input vector
%  in turn is evaluated.   QUANTITY is an optional paramater to specify
%  which aspect of the expression to evaluate and may be one of 'value',
%  'pev' or 'constraint'.  If it is not specified then 'value' is assumed.
%
%  All other pointers in the inports list that are not in SEQPTRS must not
%  contain vectors unless they are dependent on one of the pointers in
%  SEQPTRS.  All of the SEQPTRS must be independent of each other.
%
%  Example:
%
%    M is a model with 4 inputs: L, N, A, E.
%    L is a vector of length 10 with values (1:10).
%    N is a vector of length 20 with values (1:20).
%    A and E have scalar values.
%
%    The call Y = EVALUATESEQUENTIAL(M, [L N], [5, 15]) will construct the
%    following inputs for L and N:
%
%    L = [(1:10)  repmat(5, 1,20)];
%    N = [repmat(15, 1, 10)  (1:20)];
%
%    and then call i_eval on M.  The output Y will be a cell array with the
%    first cell containing the evaluation results as L is varied and the
%    second cell containing the results as N is varied:
%
%    Y = 
%        [1x10 double]
%        [1x20 double]
%  
%
%  See also CGEXPR/EVALUATE, CGEXPR/EVALUATEGRID.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.6.1 $    $Date: 2004/02/09 07:08:34 $ 

if nargin<3
    error('mbc:cgexpr:InvalidArgument', 'You must specify a list of sequential input variables and nominal values.');
end

if length(dSeqNomValues) ~= length(pSeq)
    error('mbc:cgexpr:InvalidArgument', 'The nominal values for each sequential input must be specified.');
end

if isinport(obj)
    error('mbc:cgexpr:InvalidArgument', 'The expression to be evaluated must not be an inport.');
end

% Get evaluation function flag
if nargin<4
    nQuant = 1;
else
    nQuant = strmatch(lower(sQuant), {'value', 'pev', 'constraint'});
    if isempty(nQuant)
        error('mbc:cgexpr:InvalidArgument', 'Quantity must be one of ''value'', ''pev'' or ''constraint''.');
    end
end

pInputs = getinports(obj);

% Check that the inputs are all independent of each other
if ~cgisindependentvars(pSeq)
    error('mbc:cgexpr:InvalidArgument', 'All sequential variables must be independent of each other.');
end

% Find the pointers that are not sequential variables or dependent on the
% sequential variables (this includes the sequential pointers themselves).
% All of these remaining pointers must be scalars.
pInputs = pInputs(cgisindependentvars(pInputs, pSeq));
bScalar = pveceval(pInputs, 'isscalar');
if ~all([bScalar{:}])
    error('mbc:cgexpr:InvalidArgument', 'All non-sequential inputs must be scalar values.');   
end

% Check that the expanded input formation won't consume too much memory.
% If it looks too big then the evaluation is split into an evaluation for
% each separate input.  These evaluations are unchecked for size so if an
% individual input is set too large there may still be memory problems
dValues = pveceval(pSeq, 'getvalue');
dims = cellfun('length', dValues);
nElements = sum(dims);


% LIMIT is the limit on the number of input elements
LIMIT = 2^16;
BLOCKSIZE = 2^15;
if (nElements*length(pSeq)) < LIMIT
    dSeqValues = cell(size(dValues));
    nCumElements = [0 cumsum(dims)];
    for n = 1:length(pSeq)
        inputvect = repmat(dSeqNomValues(n), nElements, 1);
        inputvect((nCumElements(n)+1):nCumElements(n+1)) = dValues{n}(:);
        dSeqValues{n} = inputvect;
    end
    passign(pSeq, pvecinputeval(pSeq, 'setvalue', dSeqValues));
    % Pre-allocating the output automatically corrects the rare cases where
    % the output of i_eval is scalar even when the grid inputs are vectors.
    dYValues = zeros(nElements, 1);
    if nQuant==1
        dYValues(:) = i_eval(obj);
    elseif nQuant==2
        dYValues(:) = peveval(obj);
    else
        dYValues(:) = ceval(obj);
    end
    clear('dSeqValues');
    Y = cell(length(pSeq),1);
    for n = 1:length(pSeq)
        Y{n} = dYValues((nCumElements(n)+1):nCumElements(n+1));
    end
else
    % Set the inputs to their nominal values
    passign(pSeq, pvecinputeval(pSeq, 'setvalue', num2cell(dSeqNomValues)));
    Y = cell(length(pSeq),1);
    for n = 1:length(pSeq)
        pSeq(n).info = pSeq(n).setvalue(dValues{n});
        YValue = zeros(size(dValues{n}));
        if nQuant==1
            YValue(:) = i_eval(obj);
        elseif nQuant==2
            YValue(:) = peveval(obj);
        else
            YValue(:) = ceval(obj);
        end
        Y{n} = YValue;
        pSeq(n).info = pSeq(n).setvalue(dSeqNomValues(n));
    end
end

passign(pSeq, pvecinputeval(pSeq, 'setvalue', dValues));
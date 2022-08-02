function Y = evaluategrid(obj, pGrid, sQuant, customFcn)
%EVALUATEGRID Evaluate expression over a grid
%
%  Y = EVALUATEGRID(OBJ, GRIDPTRS, QUANTITY) evaluates the expression OBJ
%  over a grid.  GRIDPTRS is a list of pointers to inputs to OBJ that you
%  want to create a grid over.  The output Y will be returned as an N-D
%  array with the dimensions in the same order as GRIDPTRS.   QUANTITY is
%  an optional paramater to specify which aspect of the expression to
%  evaluate and may be one of 'value', 'pev' or 'constraint'.  If it is not
%  specified then 'value' is assumed.
%
%  GRIDPTRS must only contain pointers that are in the list of inputs
%  returned by calling "getinports(OBJ)".  All other pointers in this
%  inports list must not contain vectors unless they are dependent on one
%  of the pointers in GRIDPTRS.  All of the GRIDPTRS must be independent of
%  each other.
%
%  See also CGEXPR/EVALUATE, CGEXPR/EVALUATESEQUENTIAL.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.2 $    $Date: 2004/02/09 07:08:33 $ 

if nargin<2
    error('mbc:cgexpr:InvalidArgument', 'You must specify a list of grid variables.');
end

if length(pGrid)<2
    % transfer to standard evaluate mechanism as that is faster
    if nargin<3
        Y = evaluate(obj);
    else
        Y = evaluate(obj, sQuant);
    end
    return
end


% Get evaluation function flag
if nargin<3
    nQuant = 1;
else
    nQuant = strmatch(lower(sQuant), {'value', 'pev', 'constraint', 'custom'});
    if isempty(nQuant)
        error('mbc:cgexpr:InvalidArgument', 'Quantity must be one of ''value'', ''pev'' or ''constraint''.');
    end
end
if nQuant==1
    evalFcn = @i_eval;
elseif nQuant==2
    evalFcn = @peveval;
elseif nQuant==3
    evalFcn = @ceval;
elseif nQuant==4
    evalFcn = customFcn;
end


pInputs = getinports(obj);

% Check that the inputs are all inports
if ~all(ismember(pGrid, pInputs))
    error('mbc:cgexpr:InvalidArgument', 'All grid variables must be inports to the expression.');
end

% Check that the inputs are all independent of each other
if ~cgisindependentvars(pGrid)
    error('mbc:cgexpr:InvalidArgument', 'All grid variables must be independent of each other.');
end

% Find the pointers that are not gridding variables or dependent on the
% gridding variables (this includes the grid pointers themselves).  All of
% these remaining pointers must be scalars.
pInputs = pInputs(cgisindependentvars(pInputs, pGrid));
bScalar = pveceval(pInputs, @isscalar);
if ~all([bScalar{:}])
    error('mbc:cgexpr:InvalidArgument', 'All non-grid inports must be scalar values.');   
end

dValues = pveceval(pGrid, @getvalue);
dims = cellfun('length', dValues);
nElements  = prod(dims);

% Check that the ndgrid won't consume too much memory.  If it looks big
% then the calculation is split into chunks which takes longer but will
% avoid failing or causing disk thrashing.  Note that the actual memory
% consumed is in part determined by the complexity of the expression.

% LIMIT is the limit on the number of input elements
LIMIT = 2^16;
BLOCKSIZE = 2^15;
if (nElements*length(pGrid)) < LIMIT
    dGridValues = cell(size(dValues));
    if length(dGridValues)>1
        [dGridValues{1:length(dGridValues)}] = ndgrid(dValues{:});
        for n = 1:length(dGridValues)
            dGridValues{n} = dGridValues{n}(:);
        end
    else
        dGridValues{1} = dValues{1};
    end
    passign(pGrid, pvecinputeval(pGrid, @setvalue, dGridValues));
    % Pre-allocating the output automatically corrects the rare cases where
    % the output of i_eval is scalar even when the grid inputs are vectors.
    Y = zeros(nElements, 1);
    Y(:) = feval(evalFcn, obj);
else
    dGridValues = cell(size(dValues));
    cs = cset_grid(dValues);
    nBlocks = floor(nElements./BLOCKSIZE);
    nLeftover = mod(nElements, BLOCKSIZE);
    Y = zeros(nElements,1);
    nIndex = 1:BLOCKSIZE;
    for n = 1:nBlocks
        dPoints = partialset(cs, nIndex);
        for m = 1:length(dGridValues)
            dGridValues{m} = dPoints(:,m);            
        end
        passign(pGrid, pvecinputeval(pGrid, @setvalue, dGridValues));
        Y(nIndex) = feval(evalFcn, obj);
        nIndex = nIndex+BLOCKSIZE;
    end
    if nLeftover
        % Final block is smaller
        dPoints = partialset(cs, nIndex(1:nLeftover));
        for m = 1:length(dGridValues)
            dGridValues{m} = dPoints(:,m);            
        end
        passign(pGrid, pvecinputeval(pGrid, @setvalue, dGridValues));
        Y(nIndex(1:nLeftover)) = feval(evalFcn, obj);
    end
end

passign(pGrid, pvecinputeval(pGrid, @setvalue, dValues));
if length(dims)>1
    Y = reshape(Y, dims);
end
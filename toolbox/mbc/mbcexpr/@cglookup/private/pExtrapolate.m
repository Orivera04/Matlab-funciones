function obj = pExtrapolate(obj, method, ExtrapMask, ApplyMask)
%PEXTRAPOLATE Perform interpolation/extrapolation of table values
%
%  OBJ = PEXTRAPOLATE(OBJ, METHOD, EXTRAPMASK) performs extrapolation on
%  the table values using the given extrapolation mask.  Method specifies
%  how the extrapolation will occur and can be one of 'linear' or 'rbf'.
%
%  OBJ = PEXTRAPOLATE(OBJ, METHOD, EXTRAPMASK, APPLYMASK) lets you also
%  specify a mask that controls which values in the table will be altered.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:12:00 $ 

% Flag to indicate that the extrapolation can be passed a subset of the
% values/breakpoints arrays
USE_SUB_REGION = true;

V = get(obj, 'values');
nDims = getNumAxes(obj);
if nargin<4
    % Want to apply over whole table
    ApplyMask = true(size(V));
    USE_SUB_REGION = false;
else
    % Check the ApplyMask to see if the mask is all within a sub-rectangle
    % of the table.
    idx = find(ApplyMask);
    [cLims{1:nDims}] = ind2sub(size(ApplyMask), idx);
    for n = 1:nDims
        cLims{n} = (min(cLims{n}):max(cLims{n}));
    end
end

[cBP{1:nDims}] = getDenormalizedBP(obj);

if USE_SUB_REGION
    V = V(cLims{:});
    ExtrapMask = ExtrapMask(cLims{:});
    for n = 1:nDims
        cBP{n} = cBP{n}(cLims{n});
    end
end

% Check that we have any trusted values at all
if ~any(ExtrapMask(:))
    error('mbc:cglookup:InvalidState',  ...
        'There must be at least one table cell in the extrapolation mask.');
    return
end

if all(ExtrapMask(:))
    % If all cells are trusted there is no work to do
    return
end

if isvector(V)
    % This catches both 1D tables and 1D sections in an nD table
    switch method
        case {'linear', 'auto'}
            % Find the dimension to work with
            len = cellfun('length', cBP);
            dimIdx = find((len>1));
            if isempty(dimIdx)
                % Possible case of a [1x1] value matrix
                dimIdx = 1;
            end
            newV = eval(cgmathsobject, 'extinterp1', cBP{dimIdx}(ExtrapMask), V(ExtrapMask), cBP{dimIdx});
        otherwise
            error('mbc:cglookup:invalidState',  ...
                'Extrapolation method not supported for 1D regions.');
    end
    
elseif nDims==2
    switch method
        case 'linear'
            newV = eval(cgmathsobject, 'extrapolate_values', V, ExtrapMask, cBP{2}, cBP{1});
        case {'rbf', 'auto'}
            newV = eval(cgmathsobject, 'extrapolate_values_RBF', V, ExtrapMask, cBP{2}, cBP{1});
        otherwise
            error('mbc:cglookup:invalidState',  ...
                'Extrapolation method not supported for 2D regions.');
    end
    
else
    error('mbc:cglookup:invalidState',  ...
    'No support for linear extrapolation of tables with more than 2 dimensions.');
end

if USE_SUB_REGION
    subV = V;
    subV(ApplyMask(cLims{:})) = newV(ApplyMask(cLims{:}));
    V = get(obj, 'values');
    V(cLims{:}) = subV;
else
    V(ApplyMask) = newV(ApplyMask);
end
obj = set(obj, 'values', {V, 'Extrapolated'});

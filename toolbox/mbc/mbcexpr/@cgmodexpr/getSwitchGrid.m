function gridOK = getSwitchGrid(m, pGrid)
%GETSWITCHGRID Generate a logical grid of valid sites 
%
%  GRID = GETSWITCHGRID(M, PGRID) returns a logical grid of true/false
%  values corresponding to every combination of input settings specified by
%  the gridded inports, PGRID, for the expression.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $    $Date: 2004/02/09 07:13:06 $ 

pSrc = getsource(m);
pInp = getinputs(m);
if length(pSrc)==length(pInp) ...
        && all(ismember(pSrc, pInp)) ...
        && length(unique(pInp))==length(pInp)

    % Pass on the vectors of input values to the underlying model
    vals = pveceval(pInp, @i_eval);
    gridOK = getSwitchGrid(m.model, vals{:});

    % Squeeze and permute the grid to get the requested shape
    [unused, perm] = ismember(pGrid, pInp);
    gridOK = permute(gridOK, [perm, setdiff(1:ndims(gridOK), perm)]);
    gridOK = squeeze(gridOK);
else
    gridOK = evaluategrid(m, pGrid, 'custom', @isSwitchPoint);
end

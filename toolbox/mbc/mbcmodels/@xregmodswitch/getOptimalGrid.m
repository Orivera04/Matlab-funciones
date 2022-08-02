function Grid = getOptimalGrid(obj)
%GETOPTIMALGRID Generate the optimal evaluation grid values
%
%  GridVals = GETOPTIMALGRID(OBJ) returns a cell array containing a
%  suggested vector of evaluation points for each switch factor.  The
%  evaluation points will be chosen so that the number of evaluation points
%  is minimised while still allowing every contained model site to be
%  "hit".

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:53:40 $ 

Points = obj.OpPoints;
nFact = nfactors(obj);
nSwitchFact = size(Points,2);

Grid = cell(1, nSwitchFact);

% Tolerance for comparison.  This is double the matching tolerance as it is
% the total width of the matching region
Bnds = getcode(obj, (nFact-nSwitchFact+1):nFact);
range = diff(Bnds,[],2)';
tol = 2.*getTolerance(obj).*range;

for n = 1:nSwitchFact
    % Sort and unique the values
    gridvals = unique(Points(:, n));
    nPoints = length(gridvals);
    keep = true(size(gridvals));
    anchor = 1;
    for m = 2:nPoints
        if (gridvals(m)-gridvals(anchor)) < tol(n)
            % This point can be amalgamated with previous ones
            keep(m) = false;
        else
            if (m-anchor)>1
                gridvals(anchor) = 0.5*(gridvals(m-1) + gridvals(anchor));
                thismean = gridvals(m);
            end
            anchor = m;
        end
    end
    if anchor~=m
        gridvals(anchor) = 0.5*(gridvals(end) + gridvals(anchor));
    end
    Grid{n} = gridvals(keep);
end

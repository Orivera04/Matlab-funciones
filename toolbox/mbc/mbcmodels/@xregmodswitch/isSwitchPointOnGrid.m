function isHit = isSwitchPointOnGrid(obj, varargin)
%ISSWITCHPOINTONGRID Check whether each switch point will be hit.
%
%  ISHIT = ISSWITCHPOINTONGRID(OBJ, VECT1, VECT2, ...) checks whether each
%  switch point in the model is within the tolerance of any points on the
%  n-dimensional grid formed by the given input vectors for each switch
%  factor. The return argument is a vector the same length as the number of
%  switch points in the model.  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:53:47 $ 

Points = obj.OpPoints;
nFact = nfactors(obj);
[nPoints, nSwitchFact] = size(Points);

% Tolerance for comparison.
Bnds = getcode(obj, (nFact-nSwitchFact+1):nFact);
range = diff(Bnds,[],2)';
tol = getTolerance(obj).*range;

isHit = true(nPoints,1);
for n = 1:nSwitchFact
    % Search the grid values for this factor
    gridvals = varargin{n};
    factNotHit = isHit;
    m = 1;
    while any(factNotHit) && m<=length(gridvals)
        factNotHit(factNotHit) = abs((Points(factNotHit,n) - gridvals(m))) >= tol(n);
        m = m + 1;
    end
    isHit = isHit & ~factNotHit;
end

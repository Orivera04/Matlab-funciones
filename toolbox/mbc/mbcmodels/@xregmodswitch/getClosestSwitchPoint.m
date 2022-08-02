function X = getClosestSwitchPoint(m, X)
%GETCLOSESTSWITCHPOINT Return the closest valid evaluation point
%
%  XVALID = GETCLOSESTSWITCHPOINT(M, X) returns the evaluation point that
%  is closest to the input X.  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:53:39 $ 

nf = nfactors(m);
if size(X, 2)~=nf
    error('mbc:xregmodswitch:InvalidArgument', ...
        'Number of columns in X must be equal to the number of factors in the model.');
end
if size(X, 1) >1
    error('mbc:xregmodswitch:InvalidArgument', 'X must be a single evaluation point.');
end


[nPoints,ng] = size(m.OpPoints);
swFact = getSwitchFactors(m);
% Use coded inputs to find closest point - ensures that a single variable
% does not dominate.  A temporary model is used to perform the coding.
mCode = xregmodel('nfactors', length(swFact));
[Bnds, g, Tgt] = getcode(m);
mCode = setcode(mCode, Bnds(swFact, :), g(swFact), repmat([-1 1], length(swFact),1));

codedDelta = repmat(code(mCode, X(swFact)), nPoints , 1) - code(mCode, m.OpPoints);
[dist, idx] = min(sum(codedDelta.^2, 2));
X(swFact) = m.OpPoints(idx, :);
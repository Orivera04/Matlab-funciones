function ret = isSwitchPoint(m, X)
%ISSWITCHPOINT Check whether a point is a valid evaluation site
%
%  RET = ISSWITCHPOINT(M, X) where X is a (nPoints-by-nFactors) matrix of
%  evaluation points returns a logical vector of length nPoints containing
%  true where the corresponding evaluation point is a valid evaluation site
%  for the switched model.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $    $Date: 2004/02/09 07:53:46 $ 

nf = nfactors(m);
if size(X, 2)~=nf
    error('mbc:xregmodswitch:InvalidArgument', ...
        'Number of columns in X must be equal to the number of factors in the model.');
end

[nPoints,ng] = size(m.OpPoints);
nCheckPts = size(X, 1);
swFact = getSwitchFactors(m);

% input ranges
Bnds = getcode(m, (nf-ng+1):nf);
range = diff(Bnds,[],2)';

% tolerance for comparison
tol = repmat(getTolerance(m).*range, nPoints, 1);

switchPts = m.OpPoints;
ret = false(nCheckPts, 1);
checkExp = switchPts;
for n = 1:nCheckPts
    for k = 1:ng
        % Avoid repmat within the loop so everything is JITed
        checkExp(:,k) = X(n , swFact(k));
    end
    ret(n) = any(all(abs(checkExp - switchPts) < tol, 2));
end

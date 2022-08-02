function tol = getAbsoluteTolerance(m)
%GETABSOLUTETOLERANCE Return absolute matching tolerance of switch model
%
%  TOL = GETTOLERANCE(M) returns a vector the same length as the number of
%  switching factors, containing the absolute matching tolerance for each
%  factor.  The absolute tolerance is the relative tolerance multiplied by
%  the variable range.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:53:38 $ 

% nf = nfactors(m);
% ng = size(m.OpPoints, 2);
swFact = getSwitchFactors(m);

% Input ranges
Bnds = getcode(m, swFact);
range = diff(Bnds,[],2)';

% Tolerance for comparison
tol = getTolerance(m).*range;

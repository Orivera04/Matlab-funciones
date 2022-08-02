function [lb, ub] = getBounds(sumst)
%GETBOUNDS Upper and lower bounds for free variables in sum optim
%
%  [LB, UB] = GETBOUNDS(SUMST) returns the bounds on FVARS for the
%  optimization in SUMST. The bounds are returned as a column vectors
%  and have the same structure as X0.
%
%  See also CGSUMSTORE/GETINITVALS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $    $Date: 2004/04/04 03:26:18 $

os = sumst.os;
nfreeVariables = get(os, 'numfreevariables');
nrowsData = getNumRowsInDataset(os, 'OperatingPointSet1'); 
nzt = getNonZeroWtPts(sumst);

% cgsumstore requires the bound information for lower and upper bounds to
% be a nNZTNPTS*NFREEVAR-by-1 matrix, e.g. [SPKpt1, SPKpt2, ..., EGRpt1,
% EGRpt2, ...]'
lb = get(os,'LB');
ub = get(os, 'UB');

% Future line of code if vector bounds are supported
%lb = reshape(lb(:), nfreeVariables, nrowsData);
% Current line of code
lb = repmat(lb(:), 1, nrowsData);
lb = lb';
lb = lb(nzt, :);
lb = lb(:);

% Future line of code if vector bounds are supported
% ub = reshape(ub(:), nfreeVariables, nrowsData);
% Current line of code
ub = repmat(ub(:), 1, nrowsData);
ub = ub';
ub = ub(nzt, :);    
ub = ub(:);

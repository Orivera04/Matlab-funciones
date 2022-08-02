function varSF = getvariables(SF,expr);
%GETVARIABLES
%
%  VARS = GETVARIABLES(F, EXPR) finds the variables (non-constant values)
%  that feed into the SF that also appear into expr.info.
% 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:10:42 $

exprPtrs = unique(getinports(expr.info));
fPtrs = unique(getinports(SF));
varSF = intersect(exprPtrs, fPtrs);
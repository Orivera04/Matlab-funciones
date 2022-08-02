function p = getptrs(nd)
%GETPTRS Return List of internal pointers
%
%  PTRS = GETPTRS(NODE)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $  $Date: 2004/02/09 08:37:43 $

p = getptrs(nd.cgnode);
phere = [nd.Tables, nd.FillExpressions, nd.FillMaskExpressions, nd.GraphExpressions];
phere = phere(phere~=0);

% Recurse into contained pointers
pextra = pveceval(phere, @getptrs);

p = [p, phere, vertcat(pextra{:})'];
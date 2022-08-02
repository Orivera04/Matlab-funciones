function ok=isNumJac(L)
%XREGUSERMOD/ISNUMJAC use numerical jacobian if no analytic jacobian provided

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
% $Revision: 1.2.6.1 $  $Date: 2004/02/09 08:01:18 $

[LB,UB]=range(L);
ok= isempty(feval(L.funcName,L,'jacobian',(LB+UB)'/2));
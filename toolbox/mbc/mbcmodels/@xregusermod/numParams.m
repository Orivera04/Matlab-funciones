function np= numParams(U);
% xregusermod/NUMPARAMS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:01:33 $

np= length(U.parameters);
if np==0
   np= feval(U.funcName,U,'numParams');
end
function out=pevcheck(mod)
%PEVCHECK Return ability to calculate PEV
%
%  OK = PEVCHECK(M) returns true if the model M can calculate the Predicted
%  Error Variance of itself.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:13:23 $

if isempty(mod.model)
   out = 0;
else
   out = pevcheck(mod.model);
end
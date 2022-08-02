function out=concheck(mod)
%CONCHECK Return ability to calculate constraint
%
%  OK = CONCHECK(M) returns true if the model M can calculate the constraint
%  boundary for model

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:13:00 $

if isempty(mod.model)
   out = 0;
else
   out = concheck(mod.model);
end
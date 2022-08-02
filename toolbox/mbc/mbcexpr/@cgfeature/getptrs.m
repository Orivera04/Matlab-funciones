function out = getptrs(SF)
%GETPTRS Return pointers used in a feature
%
%  PTRS = GETPTRS(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:10:38 $

out = getptrs(SF.cgexpr);
eq = SF.eqexpr;
if ~isempty(eq)
   out = [eq; getptrs(info(eq))]; 
end
mod = SF.modelexpr;
if ~isempty(mod)
   out = [out; mod; getptrs(info(mod))];
end
op = SF.oppoint;
if ~isempty(op)
   out = [out; op; getptrs(info(op))];
end
function out = getptrsnomod(SF)
%GETPTRSNOMOD Return pointers except from in models
%
%  PTRS = GETPTRSNOMOD(F)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:10:39 $

out = getptrsnomod(SF.cgexpr);
eq = SF.eqexpr;
if ~isempty(eq) & isvalid(eq)
   out = [out; eq; getptrsnomod(eq.info)]; 
end


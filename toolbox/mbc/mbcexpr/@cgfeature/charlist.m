function out = charlist(SF)
%CHARLIST Return string description of equation
%
%  STR = CHARLIST(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:10:31 $

if ~isempty(SF.eqexpr)
   out = getname(SF);
else
   out = [getname(SF),'(No Equation)'];
end
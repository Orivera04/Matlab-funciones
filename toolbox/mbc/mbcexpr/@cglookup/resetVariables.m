function  resetVariables(LT, Variables, saveval)
%RESETVARIABLES Reset variable values
%
%  RESETVARIABLES(TBL, VARS, SAVED_VALS) sets VARS to have their saved
%  values.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:12:10 $

if ~isempty(Variables)
    hVals = pvecinputeval(Variables(:), 'setvalue', saveval(:));
    % assign to heap
    passign(Variables,hVals);
end
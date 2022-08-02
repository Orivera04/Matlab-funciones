function [pActive, pTable, pPassive] = getInputs(obj)
%GETINPUTS Return inputs used in tradeoff
%
%  [PACTIVE, PTABLE, PPASSIVE] = GETINPUTS(OBJ) returns 3 pointer arrays
%  containing pointers to the various types of inputs to the tradeoff.
%  PACTIVE contains inputs that should be presented as changeable values.
%  PTABLE contains the inputs to the tables, if there are any.  These
%  values are generally fixed according to the table cell selection.
%  PPASSIVE contains pointers to the remaining variables: those that have
%  been "hidden" and should not be presented as changeable values. 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:37:34 $ 

% Get non-table inputs
pOther = pGetOtherInputs(obj);

% Split other inputs into Active and Passive using the current hidden list
% and also by looking for links to the table inputs
pHidden = getHiddenExpressions(obj);
pTable = pGetTableInputs(obj);

isactive = ~ismember(pOther, pHidden) & cgisindependentvars(pOther, pTable);
pActive = pOther(isactive);

if nargout>2
    pPassive = pOther(~isactive);
end

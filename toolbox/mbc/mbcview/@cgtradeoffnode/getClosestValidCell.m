function index = getClosestValidCell(obj, pTbl, index)
%GETCLOSESTVALIDCELL Find the closest table cell that has a valid model evaluation
%
%  INDEX = GETCLOSESTVALIDCELL(OBJ, PTBL, STARTINDEX) returns a cell array
%  containing the table indices of the cell in the table pointed to by PTBL
%  that is closest to the cell defined by the indices in the input cell
%  array STARTINDEX.  If there is no fill expression or the filling mask
%  expression does not have any invalid places, INDEX will be identical to
%  STARTINDEX.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $    $Date: 2004/04/04 03:36:26 $ 

[pFill, pMask] = getFillExpression(obj, pTbl);
if isnull(pMask) || ~pMask.isSwitchExpr
    % No need to alter the input index
    return
end

% Set the input variables to correspond to the table index given
setInputsAt(obj, 'table', index{:});

% Instruct the mask expression to go to the closest switch point
getClosestSwitchPoint(pMask.info);

% Convert the current table inputs into a cell index
hTbl = pTbl.info;
pNorm = getinputs(hTbl);
maxVal = getTableSize(hTbl) - 1;
R = min(maxVal(1), max(0,floor(pNorm(1).i_eval))) + 1;
C = min(maxVal(2), max(0,floor(pNorm(2).i_eval))) + 1;

index = {R, C};

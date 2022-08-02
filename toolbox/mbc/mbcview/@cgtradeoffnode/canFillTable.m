function canFill = canFillTable(obj, pT, varargin)
%CANFILLTABLE Check whether a table cell can be filled
%
%  CANFILL = CANFILLTABLE(OBJ, PT, ROW, COL) returns a logical vector the
%  same size of PT, containing true values where the corresponding table
%  pointed to by PT(n) can be filled at the cell (ROW, COL).  The table may
%  not be capable of being filled because either there is no fill
%  expression defined for it or the mask expression explicitly  marks the
%  cell as not having a valid evaluation.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:37:14 $ 

canFill = true(size(pT));
if isempty(canFill)
    return
end

ok = pCheckScalarInputs(obj);
if ~ok
    error('mbc:cgtradeoffnode:InvalidState', ...
        ['You must ensure that all input variables are set to be scalar', ...
        ' before checking the filling capabilities.']);
end

% Make sure the table inputs are set up for the correct cell.  We assume
% that all other inputs are set to the correct values.
obj.Tables(1).setinportsforcells(varargin{:});

% Get all of the table filling items corresponding to the specified tables
[unused, idx] = ismember(pT, obj.Tables);
pFill = obj.FillExpressions(idx);
pMask = obj.FillMaskExpressions(idx);

for n = 1:length(canFill)
    canFill(n) = ~isnull(pFill(n));
    if canFill(n)
        maskexpr = pMask(n).info;
        canFill(n) = (~isSwitchExpr(maskexpr) || isSwitchPoint(maskexpr));
    end
end

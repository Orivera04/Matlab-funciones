function obj = setFillExpression(obj, pT, pFill, pMask)
%SETFILLEXPRESSION Associate a filling expression with a table
%
%  OBJ = SETFILLEXPRESSION(OBJ, pTable, pFill) associates the expression
%  pFill with pTable.  When a tradeoff cell is "applied", values from pFill
%  will be taken and put into cells in pTable.
%
%  OBJ = SETFILLEXPRESSION(OBJ, pTable, pFill, pMask) also sets pMask as
%  the expression object that is controlling where pFill is valid.  if
%  pMask is omitted, pMask will be set equal to pFill.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:38:38 $ 

if nargin<4
    pMask = pFill;
end

idx = (pT==obj.Tables);
if ~any(idx)
    error('mbc:cgtradeoffnode:InvalidArgument', ...
        'Unable to find specified table in this tradeoff.');
end

obj.FillExpressions(idx) = pFill;
obj.FillMaskExpressions(idx) = pMask;

% Update heap copy of node
xregpointer(obj);

function [pFill, pMask] = getFillExpression(obj, pTable)
%GETFILLEXPRESSION Return table filling and validity-masking expressions
%
%  pFill = GETFILLEXPRESSION(OBJ, pTable) returns the pointer to the
%  expression that is filling pTable.
%
%  [pFill, pMask] = GETFILLEXPRESSION(OBJ, pTable) also returns the pointer
%  to the expression that is being used to define where pFill is valid.
%
%  pFill and pMask may both be null pointers if no filling expression has
%  been set for pTable.  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:37:29 $ 

idx = (pTable==obj.Tables);
if ~any(idx)
    error('mbc:cgtradeoffnode:InvalidArgument', ...
        'Unable to find specified table in this tradeoff.');
end
pFill = obj.FillExpressions(idx);
if nargout>1
    pMask = obj.FillMaskExpressions(idx);
end
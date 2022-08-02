function [obj, ok] = guiSetFillExpression(obj, pT)
%GUISETFILLEXPRESSION Display dialog for choosing a table's fill item
%
%  [OBJ, OK] = GUISETFILLEXPRESSION(OBJ, PTABLE) displays a modal dialog
%  for choosing a new filling item for the specified table in the tradeoff.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $    $Date: 2004/04/04 03:36:32 $ 

idx = (pT==obj.Tables);
if ~any(idx)
    error('mbc:cgtradeoffnode:InvalidArgument', ...
        'Unable to find specified table in this tradeoff.');
end

[pNewFill, ok] = pGuiGetFillExpression(obj, pT);
if ok
    obj = setFillExpression(obj, pT, pNewFill);
end

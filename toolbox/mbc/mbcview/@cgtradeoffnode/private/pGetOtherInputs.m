function pOther = pGetOtherInputs(obj)
%PGETOTHERINPUTS Return pointers to all inputs apart from table's
%
%  P_INPUTS = PGETOTHERINPUTS(OBJ) returns pointers to all of the inputs in
%  the tradeoff, apart from those that are feeding into the tables.  The
%  returned inputs will include any items that are filling tables and any
%  inputs to display expressions.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:38:31 $ 

pAll = [obj.FillExpressions, obj.FillMaskExpressions, obj.GraphExpressions];
pAll = pAll(~isnull(pAll));
if isempty(pAll)
    pOther = null(xregpointer,0);
else
    direct_inp = pveceval(pAll, @isinport);
    direct_inp = [direct_inp{:}];
    other_inp = pveceval(pAll(~direct_inp), @getinports);
    pOther = unique([pAll(direct_inp), other_inp{:}]);
    pOther = setdiff(pOther, pGetTableInputs(obj));
end

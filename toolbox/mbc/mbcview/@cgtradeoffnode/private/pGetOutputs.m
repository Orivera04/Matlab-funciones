function pOut = pGetOutputs(obj)
%PGETOUTPUTS Return pointers to all output expressions
%
%  PGETOUTPUTS(OBJ) returns a list of pointers to all of the output
%  expressions in the tradeoff.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:38:32 $ 

pAll = [obj.FillExpressions(~isnull(obj.FillExpressions)), obj.GraphExpressions];
if ~isempty(pAll)
    is_inp = pveceval(pAll, @isinport);
    pOut = pAll(~[is_inp{:}]);
else
    pOut = null(xregpointer, 0);
end

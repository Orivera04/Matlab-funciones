function output = i_eval(relexp)
%I_EVAL Evaluate expression
%
%  OUT = I_EVAL(OBJ) evaluates the object at its current inputs.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.7.6.1 $  $Date: 2004/02/09 07:15:19 $

if isempty(relexp)
    output = [];
else
    fcn = {'eq', 'ne', 'gt', 'lt', 'ge', 'le'};
    fcnindx = strmatch(relexp.rel,{'==','~=','>','<','>=','<='}, 'exact');
    inputs = getinputs(relexp);
    left = inputs(1).i_eval;
    right = inputs(2).i_eval;
    output = double(feval(fcn{fcnindx}, left, right));
end
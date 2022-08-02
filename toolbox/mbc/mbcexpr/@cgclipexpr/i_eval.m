function out = i_eval(c)
%I_EVAL Evaluate expression
%
%  OUT = I_EVAL(C) evaluates the expression C

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:08:09 $

inputs = getinputs(c);
if ~isempty(inputs)
    out = inputs.i_eval;
    out = max(out, c.bound(1));
    out = min(out, c.bound(2));
else
    out =[];
end



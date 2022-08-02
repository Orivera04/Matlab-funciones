function y = i_eval(obj)
%I_EVAL Evaluate expression
%
%  Y = I_EVAL(EXPR)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 07:09:20 $

if strcmp(obj.evaltype, 'logical')
    y = testconstraint(obj);
elseif strcmp(obj.evaltype, 'eval')
    y = evalconstraintfunc(obj);
elseif strcmp(obj.evaltype, 'dist')
    y = evalconstraintdist(obj);
else 
    error('mbc:cgconstraint:InvalidState', 'Unknown evaltype.');
end

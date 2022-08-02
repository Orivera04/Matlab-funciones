function out = isempty(expr)
%ISEMPTY Check if expression is ready to run
%
%  OUT = ISEMPTY(EXPR) checks whether the expression's inputs are all
%  valid.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:09:00 $ 

out = isempty(expr.Inputs) || ~all(isvalid(expr.Inputs));
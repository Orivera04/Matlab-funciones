function str = char(relexp)
%CHAR  Return a string description of the object
%
%  STR = CHAR(EXPRESSION) returns a description of the relational
%  expression.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.6.1 $  $Date: 2004/02/09 07:15:14 $

if isempty(relexp)
    str = '';
else
    inputs = getinputs(relexp);
    str = [inputs(1).getname, relexpr.rel, inputs(2).getname];
end
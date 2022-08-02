function str = charlist(relexp)
%CHARLIST Return a description of the expression
%
%  STR = CHARLIST(OBJ) returns a recursive string describing this
%  expression.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.6.1 $  $Date: 2004/02/09 07:15:15 $

if isempty(relexp)
    str = '';
else
    inputs = getinputs(relexp);
    str = ['(', inputs(1).charlist, ')', relexp.rel, '(', inputs(2).charlist, ')'];
end
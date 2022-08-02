function str = charlist(ifexp)
%CHARLIST IfExpr charlist method
%
%  STR = CHARLIST(IFEXP) returns a recursive string describing this expression

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:11:08 $

if isempty(ifexp)
    str = '';
else
    inputs = getinputs(ifexp);
    str = ['(IF (',inputs(1).charlist, ...
            ' < ',inputs(2).charlist, ...
            ') THEN ',inputs(3).charlist, ...
            ' ELSE ',inputs(4).charlist,')'];
end
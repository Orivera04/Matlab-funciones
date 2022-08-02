function str = charlistshort(ifexp)
%CHARLISTSHORT IfExpr charlist-short method.
%
%  STR = CHARLISTSHORT returns a recursive string describing this expression

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:11:09 $

if isempty(ifexp)
    str = '';
else
    str = getname(ifexp);
end
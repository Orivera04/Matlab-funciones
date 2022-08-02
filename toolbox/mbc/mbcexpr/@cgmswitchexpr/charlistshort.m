function str = charlistshort(obj)
%CHARLISTSHORT Cgmswitchexpr charlistshort method
%
%  STR = CHARLISTSHORT(OBJ) returns a recursive string describing this
%  expression.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:13:31 $

if isempty(obj)
    str = '';
else
    str = getname(obj);
end
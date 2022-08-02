function str = charlistshort(relexp)
%CHARLISTSHORT  Short description of expression method.
%
%  STR = CHARLISTSHORT(OBJ) returns a short recursive string describing
%  this expression.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.6.1 $  $Date: 2004/02/09 07:15:16 $

if isempty(relexp)
    str = '';
else
    str = getname(relexp);
end

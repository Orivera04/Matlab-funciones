function str = charlistshort(f)
%CHARLISTSHORT Cgfuncexpr charlist-short method.
%
% STR = CHARLISTSHORT(OBJ) returns a recursive string describing this
% expression. This method returns a short version of charlist.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:10:58 $

if isempty(f)
   str = '';
else
   str = getname(f);
end
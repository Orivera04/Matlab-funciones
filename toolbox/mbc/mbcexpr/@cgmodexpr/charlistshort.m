function str = charlistshort(mod)
%CHARLISTSHORT cgmodexpr charlist-short method.
%
%  S = CHARLISTSHORT(M) returns a recursive string describing this
%  expression.  This method returns a short version of charlist.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:12:59 $

if isempty(mod)
   str = '';
else
   str = getname(mod);
end
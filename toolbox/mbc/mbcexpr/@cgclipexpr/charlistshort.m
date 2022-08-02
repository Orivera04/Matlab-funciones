function str = charlistshort(c)
%CHARLISTSHORT Return short description of expression
%
%  STR = SCHARLISTSHORT(C)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:08:06 $

if isempty(c)
    str = '';
else
    str = charlistshort(info(getinputs(c)));
end

function str = charlist(c)
%CHARLIST Return longer description of expression
%
%  STR = CHARLIST(C)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:08:05 $

if isempty(c)
    str = '';
else
    str = charlist(info(getinputs(c)));
end

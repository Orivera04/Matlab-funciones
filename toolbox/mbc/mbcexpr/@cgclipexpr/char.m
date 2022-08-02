function str = char(c)
%CHAR Return string description of expression
%
%  STR = CHAR(C)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:08:04 $

if isempty(c)
    str = '';
else
    str = char(getinputs(c));
end
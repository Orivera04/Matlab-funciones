function str = char(v)
%CHAR Return description of object
%
%  STR = CHAR(VALUE)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:16:26 $

str = sprintf('%s:   %s = ',class(v), getname(v));
str = [str num2str(v.Value(:)')];
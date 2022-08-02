function str = num2booleanString(number)

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2002/11/27 17:40:16 $

if number ~= 0
    str = ' true';
else
    str = ' false';
end
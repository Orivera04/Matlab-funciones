function str=mbconoff(val)
%MBCONOFF Returns 'on' if "val" is non-zero and 'off' otherwise

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $

if val
    str = 'on';
else
    str = 'off';
end


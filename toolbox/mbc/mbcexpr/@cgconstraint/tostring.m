function str = tostring(con)
%TOSTRING Return a descriptive string
%
%  STR = TOSTRING(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.1 $    $Date: 2004/02/09 07:09:29 $

if ~isempty(con.conobj)
    inptrs = getinputs(con);
    if ~isempty(inptrs)
        valStrs = pveceval(inptrs, 'getname');
    else
        valStrs = [];
    end
    str = tostring(con.conobj, valStrs);
else
    str = '';
end

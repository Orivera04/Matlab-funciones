function str = char(d)
%CHAR Return string describing method
%
%  STR = CHAR(OBJ) returns a string describing the object.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:09:36 $

topstr = get(d,'topname');
if d.NBottom ==0
    str = topstr;
else
    if isempty(topstr);
        topstr='1';
    end
    str=[topstr,' / ',get(d,'bottomname')];
end
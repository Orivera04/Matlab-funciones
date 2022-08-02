function str = char(m)
%CHAR Return string description of object
%
%  STR = CHAR(OBJ) returns a description of the MSwitch expression.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:13:29 $

inputs = getinputs(m);
str = ['Choose from '];

if length(inputs)>1
    for n=2:length(inputs)
        str = [str,inputs(n).getname,', '];
    end
else
    str = [str '<none>'];
end

str = [str,' by value of ',inputs(1).getname];
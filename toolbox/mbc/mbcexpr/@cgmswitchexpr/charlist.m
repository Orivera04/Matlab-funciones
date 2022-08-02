function str = charlist(obj)
%CHARLIST Cgmswitchexpr charlist method
%
%  STR = CHARLIST(OBJ) returns a recursive string describing this
%  expression.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:13:30 $

if isempty(obj)
    str = '';
else
    inputs = getinputs(obj);
    if length(inputs)==1
        str = getname(obj);
    else
        str = [getname(obj),'{'];
        for ind=2:length(inputs)
            str = [str, inputs(ind).charlist,','];
        end
        str(end) = '}';
    end
end
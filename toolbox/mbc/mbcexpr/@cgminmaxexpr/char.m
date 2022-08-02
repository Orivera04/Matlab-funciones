function str = char(m)
%CHAR Return string description of object
%
%  STR = CHAR(OBJ) returns a list of the name of the expressions, together
%  with their type.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:12:45 $

if isempty(m)
    str = '';
else
    if m.min
        str = [getname(m) ' = min{'];
    else
        str = [getname(m) ' = max{'];
    end
    names = pveceval(getinputs(m), 'getname');
    str = [str, sprintf('%s, ', names{:})];
    str = str(1:end-1);
    str(end) = '}';
end
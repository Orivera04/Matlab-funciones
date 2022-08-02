function str = charlist(m)
%CHARLIST Return string description of object
%
%  STR = CHARLIST(OBJ) returns a recursive string description of the
%  object.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:12:46 $

if isempty(m)
    str = '';
else
    if m.min
        str = ['min{'];
    else
        str = ['max{'];
    end
    
    names = pveceval(getinputs(m), 'charlist');
    issrc = cellfun('isempty', pveceval(getinputs(m), 'getinputs'));
    for n = 1:length(names)
        if issrc(n)
            str = [str, names{n}, ', '];
        else
            str = [str, '(', names{n}, '), '];
        end
    end
    str = str(1:end-1);
    str(end) = '}';
end

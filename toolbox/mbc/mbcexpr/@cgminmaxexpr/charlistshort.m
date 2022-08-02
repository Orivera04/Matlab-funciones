function str = charlistshort(m)
%CHARLISTSHORT Return string description of object
%
%  STR = CHARLISTSHORT(OBJ) returns a recursive string description of the
%  object.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:12:47 $

if isempty(m)
    str = '';
else
    if m.min
        str = ['min{'];
    else
        str = ['max{'];
    end
    
    names = pveceval(getinputs(m), 'charlistshort');
    issrc = cellfun('isempty', pveceval(getinputs(m), 'getinputs'));
    issrc = [issrc{:}];
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
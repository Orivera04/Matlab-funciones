function str = charlist(d)
%CHARLIST cgsubexpr charlist method
%
%  STR = CHARLIST(OBJ) returns a recursive string describing this
%  expression.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:15:47 $

if isempty(d)
    str = '';
else
    inputs = getinputs(d);
    if d.NLeft==0
        str='';
    else
        names = pveceval(inputs(1:d.NLeft), 'charlist');
        str = sprintf('%s + ', names{:});
        str = str(1:end-3);
        if d.NLeft>1 & d.NRight>0
            str = ['(' str ')'];
        end 
    end
    
    if d.NRight==0
        rstr='';
    else
        names = pveceval(inputs(d.NLeft+1:end), 'charlist');
        rstr = sprintf('%s + ', names{:});
        rstr = rstr(1:end-3);
        if d.NRight>1 & d.NLeft>0
            rstr = ['(' rstr ')'];
        end 
        if d.NLeft
            rstr = [' - ' rstr];
        else
            rstr = ['-' rstr];
        end
    end
    str=['(' str rstr ')'];
end


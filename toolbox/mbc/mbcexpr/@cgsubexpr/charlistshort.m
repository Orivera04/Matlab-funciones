function str = charlistshort(d)
%CHARLISTSHORT cgsubexpr charlist method
%
%  STR = CHARLISTSHORT(OBJ) returns a recursive string describing this
%  expression.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:15:48 $

if isempty(d)
    str = '';
else
    allP = getptrsnosf(d);
    expand = 0;
    for i=1:length(allP)
        if allP(i).isa('Lookup') || allP(i).isa('cgfeature') || ~isempty(strmatch('Sum',getname(d)))
            expand = 1;
            break
        end
    end
    
    if expand
        inputs = getinputs(d);
        if d.NLeft==0
            str='';
        else
            names = pveceval(inputs(1:d.NLeft), 'charlistshort');
            str = sprintf('%s + ', names{:});
            str = str(1:end-3);
            if d.NLeft>1
                str = ['(' str ')'];
            end 
        end
        
        if d.NRight==0
            rstr='';
        else
            names = pveceval(inputs(d.NLeft+1:end), 'charlistshort');
            rstr = sprintf('%s + ', names{:});
            rstr = rstr(1:end-3);
            if d.NRight>1
                rstr = ['(' rstr ')'];
            end 
            if d.NLeft
                rstr = [' - ' rstr];
            else
                rstr = ['-' rstr];
            end
        end
        str=[str rstr];
    else
        str = getname(d);
    end
end
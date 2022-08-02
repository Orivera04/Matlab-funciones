function str = charlistshort(d)
%CHARLISTSHORT Cgdivexpr charlist-short method
%
%  STR = CHARLISTSHORT(OBJ) returns a recursive string describing this
%  expression.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:09:38 $

if isempty(d)
    str = '';
else
    allP = getptrsnosf(d);
    expand = 0;
    for i=1:length(allP)
        if allP(i).isa('Lookup') | allP(i).isa('cgfeature') | ~isempty(strmatch('Product',getname(d)))
            expand = 1;
            break
        end
    end
    if expand
        inputs = getinputs(d);
        subchars = pveceval(inputs, 'charlistshort');
        if d.NTop ==0
            str = '1';
        else
            str = ['(' sprintf('%s * ', subchars{1:d.NTop})];
            str = str(1:end-2);
            str(end) = ')';
        end
        if d.NBottom ~= 0
            str = [str ' / (' sprintf('%s * ', subchars{d.NTop+1:end})];
            str = str(1:end-2);
            str(end) = ')';
        end        
    else
        str = getname(d);
    end
end

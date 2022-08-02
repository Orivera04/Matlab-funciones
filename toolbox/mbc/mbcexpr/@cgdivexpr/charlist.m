function str = charlist(d)
%CHARLIST charlist method.
%
%  STR = CHARLIST(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:09:37 $

if isempty(d)
    str = '';
else
    inputs = getinputs(d);
    subchars = pveceval(inputs, 'charlist');
    if d.NTop == 0
        str = '1';
    elseif d.NTop == 1
        str = subchars{1};
    else
        if d.NBottom
            str = ['(' sprintf('%s * ', subchars{1:d.NTop})];
            str = str(1:end-2);
            str(end) = ')';
        else
            str = sprintf('%s * ', subchars{1:d.NTop});
            str = str(1:end-3);
        end     
    end
    
    if d.NBottom ==1
        str = [str ' / ' subchars{d.NTop+1}];
    elseif d.NBottom ~= 0
        str = [str ' / (' sprintf('%s * ', subchars{d.NTop+1:end})];
        str = str(1:end-2);
        str(end) = ')';
    end
end

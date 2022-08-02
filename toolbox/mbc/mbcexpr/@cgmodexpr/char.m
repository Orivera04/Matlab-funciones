function str = char(modexp)
%CHAR Create a string representation of the model
%
%  S = CHAR(M)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:12:57 $

inputs = getinputs(modexp);

if isempty(modexp.model) && isempty(inputs)
    str = '';
    
elseif ~isempty(modexp.model) && isempty(inputs)
    str = [getname(modexp) ' = ' class(modexp.model)];
    
elseif isempty(modexp.modptr) && ~isempty(inputs)
    str = 'Model expression with no model and the following inputs: ';
    for n = 1:length(inputs)
        if inputs(n).isvalid
            str = [str getname(inputs(n).info) ','];
        else
            str = [str '<none>,'];
        end
    end
    str(end) = '.';
    
else
    mod = modexp.model;
    str = [getname(modexp) ' = ' getname(mod) '( '];
    for n = 1:length(inputs)
        L = inputs(n);
        if isvalid(L)
            expression = L.info;
            name = getname(expression);
        else
            name = '<none>';
        end
        str = [str name ','];
    end
    str(end) = ')';
end
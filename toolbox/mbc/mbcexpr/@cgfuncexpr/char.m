function str = char(funcexp)
%CHAR Return string description of object
%
%  STR = CHAR(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:10:56 $

%Return a list of the name of the expressions, together with their type.

inputs = getinputs(funcexp);
if isempty(funcexp.function) & isempty(inputs)
   str = '';
   
elseif ~isempty(funcexp.function) & isempty(inputs)
   str = [getname(funcexp) ' = ' class(funcexp.function)];
   
elseif isempty(funcexp.function) & ~isempty(inputs)
   names = pveceval(inputs, 'getname');
   str = ['funcexpr with no model, and the following inputs: ', sprintf('%s, ', names{:})];
   str = str(1:end-1);
   str(end) = '.';
   
else
    names = pveceval(inputs, 'getname'); 
    str = [getname(funcexp) ' = ' getname(funcexp.function) '( ', ...
            sprintf('%s, ', names{:})];
    str = str(1:end-1);
    str(end) = ')';
end
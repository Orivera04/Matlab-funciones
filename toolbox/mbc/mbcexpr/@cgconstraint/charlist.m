function str = charlist(obj)
%CHARLIST Full string describing expression
%
%  STR = CHARLIST(OBJ) is a recursive description of the expression OBJ.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 07:09:12 $ 

if isempty(obj)
    str = 'Constraint()';
else
    inputstr = pveceval(getinputs(obj), 'charlist');
    str = tostring(obj.conobj, inputstr);
end
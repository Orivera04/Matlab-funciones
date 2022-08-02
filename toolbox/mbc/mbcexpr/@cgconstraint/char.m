function str = char(obj)
%CHAR Return char description of expression
%
%  S = CHAR(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 07:09:11 $ 

if isempty(obj)
    str = 'Constraint';
else
    inputstr = pveceval(getinputs(obj), 'getname');
    str = tostring(obj.conobj, inputstr);
end
function result = isnonlinear(h)
%ISNONLINEAR Is this a nonlinear circuit.
%   RESULT = ISNONLINEAR(H) returns TRUE if the object is a nonlinear circuit,
%   and FALSE if it's not. 

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:37:33 $

setflagindexes(h);

% Get the flag
cflag = get(h, 'Flag');
% Check the property if needed
if bitget(cflag, indexOfThePropertyIsChecked) == 0
    checkproperty(h);
end
% Check the flag
cflag = get(h, 'Flag');
if bitget(cflag, indexOfNonLinear)==1
    result = true;
else
    result = false;
end

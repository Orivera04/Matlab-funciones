function data = calculate(h, parameter)
%CALCULATE Calculate the required power parameter.
%   DATA = CALCULATE(H, PARAMETER) calculates the required parameter and
%   returns it.
%
%   The first input is the handle to this object, the second input is the
%   parameter that can be visualized from this object. 

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:38:34 $


% Set the default for returned data
data = []; 

% Calculate the noise data
switch upper(parameter)
case 'FMIN'
    data = get(h, 'FMIN');
    % data = 10.^(realdata/10);
case 'GAMMAOPT'
    data = get(h, 'GAMMAOPT');
case 'RN'
    data = get(h, 'RN');
otherwise
    id = sprintf('rf:%s:calculate:InvalidInput', strrep(class(h),'.',':'));
    error(id, sprintf('Invalid input parameter: %s.',parameter));
end
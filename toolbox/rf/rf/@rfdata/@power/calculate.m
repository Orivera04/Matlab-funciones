function data = calculate(h, parameter)
%CALCULATE Calculate the required power parameter.
%   DATA = CALCULATE(H, PARAMETER) calculates the required parameter and
%   returns it.
%
%   The first input is the handle to this object, the second input is the
%   parameter that can be visualized from this object. 

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:38:37 $

% Set the defaults
data = [];

% Get the properties
poutcell = get(h, 'Pout');
phasecell = get(h, 'Phase');

% Calculate the data
switch upper(parameter)
case 'POUT'
    numtrace = length(poutcell);
    for k=1:numtrace
        data{k} = poutcell{k};
    end
case 'PHASE'
    numtrace = length(phasecell);
    for k=1:numtrace
        data{k} = phasecell{k};
    end
case 'AM/AM'
    numtrace = length(poutcell);
    for k=1:numtrace
        data{k} = sqrt(2* 50 * poutcell{k});
    end
case 'AM/PM'
    numtrace = length(phasecell);
    for k=1:numtrace
        data{k} = unwrap(phasecell{k}) * pi/180;
    end
otherwise
    id = sprintf('rf:%s:calculate:InvalidInput', strrep(class(h),'.',':'));
    error(id, sprintf('Do not recoganize the input: %s.', parameter));
end
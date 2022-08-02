function h = updatepower(h,pfreq,pin,power,phase)
%UPDATEPOWER Update the PowerData with the inputs.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:38:44 $

% Get the properties
powerdata = get(h, 'PowerData');

% Update the properties

if ~isempty(pin) && ~isempty(power)
    if isa(powerdata, 'rfdata.power')
        set(powerdata, 'Freq', pfreq, 'Pin', pin, 'Pout', power, 'Phase', phase);
    else
        powerdata = rfdata.power('Freq', pfreq, 'Pin', pin, 'Pout', power, ...
            'Phase', phase);
        set(h, 'PowerData', powerdata);
    end
else
    set(h, 'PowerData', []);
end

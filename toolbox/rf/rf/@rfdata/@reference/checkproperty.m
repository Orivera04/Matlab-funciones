function checkproperty(h)
%CHECKPROPERTY Check the properties of the object.
%   CHECKPROPERTY(H) checks the properties of the object.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:38:40 $

% Get the properties
netdata = get(h, 'NetworkData');
noisedata = get(h, 'NoiseData');
powerdata = get(h, 'PowerData');

% Check the properties
if isa(netdata, 'rfdata.network')
    checkproperty(netdata);
end
if isa(noisedata, 'rfdata.noise')
    checkproperty(noisedata);
end
if isa(powerdata, 'rfdata.power')
    checkproperty(powerdata);
end

function checkproperty(h)
%CHECKPROPERTY Check the properties of the object.
%   CHECKPROPERTY(H) checks the properties of the object.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:38:30 $

% Get the properties
type = get(h, 'Type');
data = get(h, 'Data');
freq = get(h, 'Freq');
z0 = get(h, 'Z0');

% Check the freq, data and z0
if isempty(data)
    id = sprintf('rf:%s:checkproperty:EmptyNetworkParameters', strrep(class(h),'.',':'));
    error(id, 'The object does not have network parameters.');
end
[m1, m2, m3] = size(data);
[n1, n2] = size(freq);
if ((n1~=1) && (n2~=1))
    id = sprintf('rf:%s:checkproperty:WrongFrequency', strrep(class(h),'.',':'));
    error(id, 'Frequency must be a vector of length M.');
end
if n1 == 1 && n2 >1
    freq = freq';
    [n1, n2] = size(freq);
    set(h, 'Freq', freq);
end
if ~(n1==m3)
    id = sprintf('rf:%s:checkproperty:WrongFrequency', strrep(class(h),'.',':'));
    error(id, 'Frequency must be a vector of length M.');
end
[k1, k2] = size(z0);
if ((k1~=1) && (k2~=1))
    id = sprintf('rf:%s:checkproperty:WrongImpedance', strrep(class(h),'.',':'));
    error(id, 'The reference impedance must be a scalar or vector of length M.');
end
if k1 == 1 && k2 >1
    z0 = z0';
    [k1, k2] = size(z0);
    set(h, 'Z0', z0);
end
if ~((k1==1 && k2==1) || (k1==m3))
    id = sprintf('rf:%s:checkproperty:WrongImpedance', strrep(class(h),'.',':'));
    error(id, 'The reference impedance must be a scalar or vector of length M.');
end

% Check the type
switch upper(type)
case {'S_PARAMETERS' 'S-PARAMETERS' 'S_PARAMS' 'S-PARAMS' 'S' ...
    'Y_PARAMETERS' 'Y-PARAMETERS' 'Y_PARAMS' 'Y-PARAMS' 'Y' ...
    'Z_PARAMETERS' 'Z-PARAMETERS' 'Z_PARAMS' 'Z-PARAMS' 'Z' ...
    'H_PARAMETERS' 'H-PARAMETERS' 'H_PARAMS' 'H-PARAMS' 'H' ...
    'ABCD_PARAMETERS' 'ABCD-PARAMETERS' 'ABCD_PARAMS' 'ABCD-PARAMS' 'ABCD' ...
    'S_PARAMETERS' 'S-PARAMETERS' 'S_PARAMS' 'S-PARAMS' 'S'}
    return;

otherwise
    id = sprintf('rf:%s:checkproperty:WrongType', strrep(class(h),'.',':'));
    error(id, sprintf('Do not recognize the type of network parameters:%s.', type));
end

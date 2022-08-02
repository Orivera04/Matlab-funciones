function data = calculate(h, parameter, z0, zl, zs)
%CALCULATE Calculate the required power parameter.
%   DATA = CALCULATE(H, PARAMETER, Z0, Zl, ZS) calculates the required
%   parameter and returns it.
%
%   The first input is the handle to this object, the second input is the
%   parameter that can be visualized from this object.  Z0 is the reference
%   impedance. If not given, the stored Z0 is used.  ZL is the load
%   impedance. If not given, 50 Ohms is used.  ZS is the source impedance.
%   If not given, 50 Ohms is used. 

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:38:29 $


% Set the default for returned data
data = []; 

% Get the paramsmeters
own_z0 = get(h, 'Z0');
if nargin < 3; z0 = own_z0; end;
if nargin < 4; zl = 50; end;
if nargin < 5; zs = 50; end;
sdata = extract(h, 'S_Parameters');
[m1, m2, m3] = size(sdata);
nport = m1;

switch upper(parameter)
case 'GAMMAIN'
    data = gammain(sdata, z0, zl);
case 'GAMMAOUT'
    data = gammaout(sdata, z0, zs);
case 'VSWRIN'
    gamma = gammain(sdata, z0, zl);
    data = vswr(gamma);
case 'VSWROUT'
    gamma = gammaout(sdata, z0, zs);
    data = vswr(gamma);
otherwise
    if strncmpi(parameter(1), 'S', 1)
        [index1, index2] = indexes(h, parameter, nport);
        if 0 < index1 && index1 <= nport && 0 < index2 && index2 <= nport
            data = sdata(index1, index2, :);
            data = data(:);
            return;
        end
    end
    id = sprintf('rf:%s:calculate:InvalidInput', strrep(class(h),'.',':'));
    error(id, sprintf('Invalid input parameter: %s.', parameter));
end


function [index1, index2] = indexes(h, parameter, nport)
% Indexes of network parameters

% Set the defaults 
index1 = 0;
index2 = 0;

if strncmpi(parameter(1), 'S', 1) && (length(parameter)==3)
    index1 = str2num(parameter(2));
    index2 = str2num(parameter(3));
    if  0 < index1 && index1 <= nport && 0 < index2 && index2 <= nport
        return;
    end
end
id = sprintf('rf:%s:calculate:InvalidInput', strrep(class(h),'.',':'));
error(id, sprintf('Invalid input parameter: %s.',parameter));


function list = listformat(h, parameter)
%LISTFORMAT List the valid formats for the specified PARAMETER.
%   LIST = LISTFORMAT(H, PARAMETER) lists the valid formats for the
%   specified PARAMETER.
%    
%   Type LISTPARAM(H) to get the valid parameters of the data object.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision.3 $  $Date: 2004/04/12 23:38:18 $

% Set the default
list = {};

refobj = get(h, 'Reference');

% Determine the format
switch upper(parameter)
case {'OIP3'}
    list = {'dBm' 'dBW' 'W' 'mW'};

case {'POUT'}
    if isa(refobj, 'rfdata.reference')
        if isa(get(refobj,'PowerData'), 'rfdata.power') 
            list = {'dBm' 'dBW' 'W' 'mW'};
        end
    end
  
case {'PHASE'}
    if isa(refobj, 'rfdata.reference')
        if isa(get(refobj,'PowerData'), 'rfdata.power') 
            list = {'Angle' 'Angle (degrees)' 'Angle (radians)'};
        end
    end
  
case {'AM/AM'}
    if isa(refobj, 'rfdata.reference')
        if isa(get(refobj,'PowerData'), 'rfdata.power') 
            list = {'dB' 'Magnitude (decibels)' 'Mag' 'Magnitude (linear)' 'None'};
        end
    end

case {'AM/PM'}
    if isa(refobj, 'rfdata.reference')
        if isa(get(refobj,'PowerData'), 'rfdata.power') 
            list = {'Angle' 'Angle (degrees)' 'Angle (radians)'};
        end
    end

case {'PHASENOISE'}
    list = {'dBc/Hz'};
  
case {'FMIN'}
    if isa(refobj, 'rfdata.reference')
        if isa(get(refobj,'NoiseData'), 'rfdata.noise') 
            list = {'dB' 'Magnitude (decibels)' 'Mag' 'Magnitude (linear)' 'None'};
        end
    end
  
case {'GAMMAIN' 'GAMMAOUT'}
    nport = getnport(h);
    if (~isempty(get(h,'Freq')) && ~isempty(get(h,'S_Parameters'))) && nport == 2
        list = {'dB' 'Magnitude (decibels)' 'Abs' 'Mag' 'Magnitude (linear)' 'Angle' 'Angle (degrees)' 'Angle (radians)' 'Real' 'Imag' 'Imaginary'};
    end
  
case {'GAMMAOPT'}
    if isa(refobj, 'rfdata.reference')
        if isa(get(refobj,'NoiseData'), 'rfdata.noise') 
            list = {'dB' 'Magnitude (decibels)' 'Abs' 'Mag' 'Magnitude (linear)' 'Angle' 'Angle (degrees)' 'Angle (radians)' 'Real' 'Imag' 'Imaginary'};
        end
    end
 
case {'RN'}
    if isa(refobj, 'rfdata.reference')
        if isa(get(refobj,'NoiseData'), 'rfdata.noise') 
            list = {'None'};
        end
    end

case {'VSWRIN' 'VSWROUT' 'NF'}
    nport = getnport(h);
    if (~isempty(get(h,'Freq')) && ~isempty(get(h,'S_Parameters'))) && nport == 2
        list = {'dB' 'Magnitude (decibels)' 'Mag' 'Magnitude (linear)'  'None'};
    end

otherwise
	if  (strncmpi(parameter(1), 'S', 1) && (length(parameter)==3)),
        nport = getnport(h);
        index1 = str2num(parameter(2));
        index2 = str2num(parameter(3));
        if (~isempty(get(h,'Freq')) && ~isempty(get(h,'S_Parameters')))
            if  ((0 < index1) && (index1 <= nport) && (0 < index2) && (index2 <= nport))
                list = {'dB' 'Magnitude (decibels)' 'Abs' 'Mag' 'Magnitude (linear)' 'Angle' 'Angle (degrees)' 'Angle (radians)' 'Real' 'Imag' 'Imaginary'};
            end
        end
    end
end

if isempty(list)
    id = sprintf('rf:%s:listformat:InvalidInput', strrep(class(h),'.',':'));
    error(id, sprintf('Invalid input parameter: %s.',parameter));
else
    list = list';
end
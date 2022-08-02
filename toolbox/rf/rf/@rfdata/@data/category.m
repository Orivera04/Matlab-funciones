function dcategory = category(h, parameter)
%CATEGORY Check and find the category of the specified parameter.
%   DCATEGORY = CATEGORY(H, PARAMETER) checks the PARAMETER and returns
%   its category. 
%
%   Type LIST(H) to see the valid parameter for th data object.
  
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.6 $  $Date: 2004/04/12 23:38:09 $

% Set the default
dcategory = '';      

refobj = get(h, 'Reference');

% Check the data to find its category
switch upper(parameter)
case {'POUT' 'PHASE'}
    if isa(refobj, 'rfdata.reference')
        if isa(get(refobj,'PowerData'), 'rfdata.power') 
            dcategory = 'Power Parameters';
        end
    end
case {'AM/AM' 'AM/PM'}
    if isa(refobj, 'rfdata.reference')
        if isa(get(refobj,'PowerData'), 'rfdata.power') 
            dcategory = 'AMAM/AMPM Parameters';
        end
    end
case {'FMIN' 'GAMMAOPT' 'RN'}
    if isa(refobj, 'rfdata.reference')
        if isa(get(refobj,'NoiseData'), 'rfdata.noise') 
            dcategory = 'Noise Parameters';
        end
    end
case {'PHASENOISE'}
    if ~isempty(h.FreqOffset) && ~isempty(h.PhaseNoiseLevel)
        dcategory = 'Phase Noise';
    end
case {'GAMMAIN' 'GAMMAOUT' 'VSWRIN' 'VSWROUT' 'NF' 'OIP3'}
    nport = getnport(h);
    if ~isempty(get(h,'Freq')) && ~isempty(get(h,'S_Parameters')) ...
        && nport == 2
        dcategory = 'Network Parameters';
    end
otherwise
    if  strncmpi(parameter(1), 'S', 1) && (length(parameter)==3)
        index1 = str2num(parameter(2));
        index2 = str2num(parameter(3));
        nport = getnport(h);
        if ~isempty(get(h,'Freq')) && ~isempty(get(h,'S_Parameters')) ...
            && 0 < index1 && index1 <= nport && 0 < index2 && index2 <= nport
            dcategory = 'Network Parameters';
        end
    end
end

if isempty(dcategory)
    id = sprintf('rf:%s:category:InvalidInput', strrep(class(h),'.',':'));
    error(id, sprintf('Invalid input parameter: %s.',parameter));
end
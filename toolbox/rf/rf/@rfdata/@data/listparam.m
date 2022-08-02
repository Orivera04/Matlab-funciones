function list = listparam(h)
%LISTPARAM List the valid parameters for the data object.
%   LIST = LISTPARAM(H) lists the valid parameters that can be visualized
%   for the data object.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.7 $  $Date: 2004/04/12 23:38:19 $

% Set the default
list = {};

refobj = get(h, 'Reference');
% Add the network parameters
if ~isempty(get(h,'Freq')) && ~isempty(get(h,'S_Parameters')) 
    nport = getnport(h);
    for i=1:nport
        for j=1:nport
            parameter = strcat('S', num2str(i), num2str(j));
            list(end+1) = {parameter};
       end
    end
    if nport == 2
        list(end+1:end+6) = {'GAMMAIn' 'GAMMAOut' 'VSWRIn' 'VSWROut' 'OIP3' 'NF'};
    end
end

% Add the noise parameters
if isa(refobj, 'rfdata.reference')
    if isa(get(refobj,'NoiseData'), 'rfdata.noise') 
        list(end+1:end+3) = {'FMIN' 'GAMMAOPT' 'RN'};
    end
end

% Add the Pout parameters
if isa(refobj, 'rfdata.reference')
    if isa(get(refobj,'PowerData'), 'rfdata.power') 
        list(end+1:end+4) = {'POUT' 'PHASE' 'AM/AM' 'AM/PM'};
    end
end

% Add the Phase Noise
if ~isempty(h.FreqOffset) && ~isempty(h.PhaseNoiseLevel)
    list(end+1) = {'PhaseNoise'};
end

% If empty data object, throw error
if isempty(list)
    id = sprintf('rf:%s:listparam:EmptyData', strrep(class(h),'.',':'));
    error(id, 'There is no data in this data object.');
else
    list = list';
end

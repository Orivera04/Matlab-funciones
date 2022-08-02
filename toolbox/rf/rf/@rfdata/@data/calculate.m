function [data, params] = calculate(varargin)
%CALCULATE Calculate the required parameters.
%   [DATA, PARAMS] = CALCULATE(H, PARAMETER1, ..., PARAMETERN, FORMAT) 
%   calculates the required parameters for the data object and returns them
%   in cell array data.
%
%   The first input is the handle to the data object, the last input is the
%   FORMAT, and the other inputs (PARAMETER1, ..., PARAMETERN) are the
%   parameters that can be visualized from the data object. 
%
%   Type LISTPARAM(H) to see the valid parameters for the data object.  
%
%   Type LISTFORMAT(H, PARAMETER) to see the valid formats for the
%   specified PARAMETER.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.7 $  $Date: 2004/04/12 23:38:08 $

% Get the object
h = varargin{1};

% Set the default for returned data
params = {};
data = {}; 

if nargin < 3; return; end;

% Check the input format. If the input FORMAT is not right, return.
if ~checkformat(h, varargin{2:end}); return; end;       

% Get the type
paramtype = category(h, varargin{2});

% Calculate the required data
k1 = 0;      
k2 = 0;
format = varargin{end};
nport = getnport(h);
for i = 2:nargin-1
    % Check the data
    parameter = varargin{i};
    dtype = category(h, parameter);
    if ~strcmp(paramtype, dtype)
        id = sprintf('rf:%s:calculate:CategoryNotConsistent',strrep(class(h),'.',':'));
        error(id, 'All the parameters must be of same category.');
    end
    switch dtype
    case 'Network Parameters'
        % Get the S-parameters
        cdata = get(h, 'S_Parameters');
        if isempty(cdata)
            warning(sprintf('No network parameters to calculate: %s.', parameter));
        else
            % Calculate the required data
            k1 = k1 + 1;
            params{k1} = modifyname(h, parameter, nport);       
            data{k1} = netcalculate(h, cdata, parameter, nport, get(h,'Z0'), ...
                get(h,'ZL'), get(h,'ZS'), format); 
        end
    case 'Noise Parameters'
        % Get the noise data
        refobj = get(h, 'Reference');
	    if isa(refobj, 'rfdata.reference')
	        noisedata = get(refobj, 'NoiseData'); 
	    else
	        noisedata = [];
	    end
        if ~isa(noisedata, 'rfdata.noise')
            warning(sprintf('No noise parameters to calculate: %s.', parameter));
        else
            % Calculate the required data
            k1 = k1 + 1;
            params{k1} = modifyname(h, parameter, nport);       
            temp = calculate(noisedata, parameter);
            if strcmpi(parameter,'FMIN') && (strcmpi(format,'DB') || ...
                    strcmpi(format,'MAGNITUDE (DECIBELS)'))
                data{k1} = formatting(h, temp, 'DB10');
            else
                data{k1} = formatting(h, temp, format);
            end
        end
    case 'Phase Noise'
        % Get the phase noise data
        k1 = k1 + 1;
        params{k1} = modifyname(h, parameter, nport);       
        temp = h.PhaseNoiseLevel;
        data{k1} = formatting(h, temp, 'None');
    case {'Power Parameters' 'AMAM/AMPM Parameters'}
        % Get the Pout data
        refobj = get(h, 'Reference');
	    if isa(refobj, 'rfdata.reference')
	        powerdata = get(refobj, 'PowerData'); 
	    else
	        powerdata = [];
	    end
        if ~isa(powerdata, 'rfdata.power')
            warning(sprintf('No PowerData data to calculate: %s.', parameter));
        else
            % Calculate the required data
            k1 = k1 + 1;
            params{k1} = modifyname(h, parameter, nport);       
            realdata = calculate(powerdata, parameter); 
            numtrace = length(realdata);
            if strcmpi(parameter,'PHASE')
              pdata = formatting(h, realdata,'none',numtrace);
            else
              pdata = formatting(h, realdata, format, numtrace);
            end
            
            k2 = k2 + numtrace;
            for k=1:numtrace
                data{k2-numtrace+k} = pdata{k};
            end
        end
    end
end


function result = netcalculate(h, netdata, parameter, nport, z0, zl, zs, reqformat)
% Calculate the data from the network parameters

switch upper(parameter)
case 'GAMMAIN'
    complexdata = gammain(netdata, z0, zl);
    % Format the required data
    result = formatting(h, complexdata, reqformat);
case 'GAMMAOUT'
    complexdata = gammaout(netdata, z0, zs);
    % Format the required data
    result = formatting(h, complexdata, reqformat);
case 'VSWRIN'
    complexdata = gammain(netdata, z0, zl);
    realdata = vswr(complexdata);
    % Format the required data
    result = formatting(h, realdata, reqformat);
case 'VSWROUT'
    complexdata = gammaout(netdata, z0, zs);
    realdata = vswr(complexdata);
    % Format the required data
    result = formatting(h, realdata, reqformat);
case 'NF'
    realdata = get(h, 'NF');
    if isempty(realdata)
        realdata = repmat(1, length(get(h, 'Freq')), 1);
    elseif isscalar(realdata)
        realdata = repmat(realdata, length(get(h, 'Freq')), 1);
    end
    % Format the required data
    if strcmpi(reqformat,'DB') || strcmpi(reqformat,'MAGNITUDE (DECIBELS)')
        result = formatting(h, realdata, 'DB10');
    else
        result = formatting(h, realdata, reqformat);
    end
case 'OIP3'
    realdata = get(h, 'OIP3');
    if isempty(realdata)
        realdata = repmat(Inf, length(get(h, 'Freq')), 1);
    elseif isscalar(realdata)
        realdata = repmat(realdata, length(get(h, 'Freq')), 1);
    end
    % Format the required data
    result = formatting(h, realdata, reqformat);
otherwise
    if strncmpi(parameter(1), 'S', 1)
        [index1, index2] = indexes(h, parameter, nport);
        if 0 < index1 && index1 <= nport && 0 < index2 && index2 <= nport
            complexdata = netdata(index1, index2, :);
            complexdata = complexdata(:);
            % Format the required data
            result = formatting(h, complexdata, reqformat);
            return;
        end
    end
    id = sprintf('rf:%s:calculate:InvalidInput', strrep(class(h),'.',':'));
    error(id, sprintf('Invalid input parameter: %s.', parameter));
end


function result = formatting(h, data, reqformat, numtrace)
% Format the data

% Set the default result
result = [];

% Check the data
if isempty(data); 
    return; 
end

% Update the result according to the required format
if ~iscell(data)
    switch upper(reqformat)
    case {'DB' 'MAGNITUDE (DECIBELS)'}
        result = 20.*log10(abs(data)+eps);
    case {'DB10'}
        result = 10.*log10(abs(data)+eps);
    case 'REAL'
        result = real(data);
    case {'IMAG' 'IMAGINARY'}
        result = imag(data);
    case {'ABS' 'MAG' 'MAGNITUDE (LINEAR)'}
        result = abs(data);
    case {'ANGLE' 'ANGLE (DEGREES)'}
        result = unwrap(angle(data)) * 180 / pi;
    case 'ANGLE (RADIANS)'
        result = unwrap(angle(data));
    case 'NONE'
        result = data;
    case 'DBM'
        result = 10.*log10(abs(data)+eps) + 30;
    case 'DBW'
        result = 10.*log10(abs(data)+eps);
    case {'W' 'WATTS'}
        result = abs(data);
    case 'MW'
        result = 1000 * abs(data);
    otherwise
        result = [];
    end
else
    % Get the numtrace
    if nargin < 3; 
        numtrace = 1;
    end
    switch upper(reqformat)
    case {'DB' 'MAGNITUDE (DECIBELS)'}
        for k=1:numtrace
            result{k} = 20.*log10(abs(data{k})+eps);
        end
    case {'DB10'}
        for k=1:numtrace
            result{k} = 10.*log10(abs(data{k})+eps);
        end
    case 'REAL'
        for k=1:numtrace
            result{k} = real(data{k});
        end
    case {'IMAG' 'IMAGINARY'}
        for k=1:numtrace
            result{k} = imag(data{k});
        end
    case {'ABS' 'MAG' 'MAGNITUDE (LINEAR)'}
        for k=1:numtrace
            result{k} = abs(data{k});
        end
    case {'ANGLE' 'ANGLE (DEGREES)'}
        for k=1:numtrace
            result{k} = unwrap(angle(data{k})) * 180 / pi;
        end
    case {'ANGLE (RADIANS)'}
        for k=1:numtrace
            result{k} = unwrap(angle(data{k}));
        end
    case 'NONE'
        for k=1:numtrace
            result{k} = data{k};
        end
    case 'DBM'
        for k=1:numtrace
            result{k} = 10.*log10(abs(data{k})+eps) + 30;
        end
    case 'DBW'
        for k=1:numtrace
            result{k} = 10.*log10(abs(data{k})+eps);
        end
    case {'W' 'WATTS'}
        for k=1:numtrace
            result{k} = abs(data{k});
        end
    case 'MW'
        for k=1:numtrace
            result{k} = 1000 * abs(data{k});
        end
    otherwise
        result = {};
    end
end


function out = modifyname(h, parameter, nport)
% Modify the name

% Set the default result
out = parameter;

% Check the data
if isempty(parameter); 
    return; 
end

switch upper(parameter)
case 'POUT'
    out = 'P_{out}';
case 'PHASE'
    out = 'Phase';
case 'AM/AM'
    out = 'AM of Output';
case 'AM/PM'
    out = 'PM of Output';
case 'FMIN'
    out = 'F_{min}';
case 'GAMMAOPT'
    out = '\Gamma_{opt}';
case 'RN'
    out = parameter;
case 'GAMMAIN'
    out = '\Gamma_{in}';
case 'GAMMAOUT'
    out = '\Gamma_{out}';
case 'VSWRIN'
    out = 'VSWR_{in}';
case 'VSWROUT'
    out = 'VSWR_{out}';
case 'NF'
    out = 'NF';
case 'OIP3'
    out = 'OIP3';
case 'PHASENOISE'
    out = 'PhaseNoise';
otherwise
    if  strncmpi(parameter(1), 'S', 1) 
        [index1, index2] = indexes(h, parameter, nport);
        out = sprintf('S_{%i%i}', index1, index2);
    else
        id = sprintf('rf:%s:calculate:InvalidInput', strrep(class(h),'.',':'));
        error(id, sprintf('Invalid input: %s.', parameter));
    end
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


function isOK = checkformat(h, varargin)
%CHECKFORMAT Check the format of parameter.

% Set the default result
isOK = false;
format = '';

% Check the format
if nargin >= 3
    reqformat = varargin{end};
    switch upper(reqformat)
    case {'ABS' 'DB' 'MAGNITUDE (DECIBELS)' 'MAG' 'MAGNITUDE (LINEAR)' ...
            'ANGLE' 'ANGLE (DEGREES)' 'ANGLE (RADIANS)' 'REAL' 'IMAG' ...
            'IMAGINARY' 'DBM' 'DBW' 'W' 'WATTS' 'MW' 'OHMS' 'DBC/HZ'}
        format = reqformat;
    case 'NONE'
        format = reqformat;
        isOK = true;
        return;
    otherwise
        id = sprintf('rf:%s:calculate:InvalidFormat', strrep(class(h),'.',':'));
        error(id, sprintf('Invalid format input: %s.', reqformat));
    end
    
    % Check the input FORMAT 
    for k=1:nargin-2
        isOK = false;
        % Get a paramater
        parameter = varargin{k};
        % Get its legitimate formats
        validformats = h.listformat(parameter);
        m = length(validformats);
        % Compare the input FORMAT with the parameters's legitimate formats
        for j=1:m
            if strcmpi(validformats{j}, format)
                isOK = true;
                break;
            end
        end
        if ~isOK;
            id = sprintf('rf:%s:calculate:InvalidFormat', strrep(class(h),'.',':'));
            error(id,sprintf('Invalid format input: %s for the parameter: %s.', format, parameter));
        end
    end
end
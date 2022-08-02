function [xname, xdata, xunit] = xaxis(h, ptype, format, pfreq)
%XAXIS Get the name, value and unit for x-axis.
%   [XNAME, XDATA, XUNIT] = XAXIS(H, PTYPE, FORMAT, PFREQ) calculate the
%   value and unit and modify its name for X-axis.

%   Copyright 2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2004/03/05 18:21:41 $

% Set the defaults
xname = '';
xdata = [];
xunit = '';
refobj = get(h, 'Reference');

switch ptype
case 'Network Parameters'
    % Get the xdata 
    data = get(h, 'Freq');
    if isempty(data)
        sparams = get(h, 'S_Parameters');
        [n1,n2,m] = size(sparams);
        data = [1:m]';
    end
    % Scaling Freq
    [xname, xdata, xunit] = scalingfrequency(data);
    
case 'Noise Parameters'
    % Get the xdata 
    if isa(refobj, 'rfdata.reference')
        if isa(get(refobj,'NoiseData'), 'rfdata.noise') 
            % data = get(h, 'Freq');
            data = get(get(refobj, 'NoiseData'), 'Freq');
            if isempty(data)
                params = get(get(refobj, 'NoiseData'), 'FMIN');
                [m, k] = size(params);
                data = [1:m]';
            end
            % Scaling NoiseFreq
            [xname, xdata, xunit] = scalingfrequency(data);
        end
    end
    
case 'Phase Noise'
    % Get the xdata 
    data = get(h, 'FreqOffset');
    % Scaling Freq Offset
    [xname, xdata, xunit] = scalingfrequency(data);
    
case 'Power Parameters'
    if isa(refobj, 'rfdata.reference')
        pout = get(refobj,'PowerData');
        if nargin == 4
            if ~isa(pout, 'rfdata.power') 
                data = [];
            else
                data = get(pout, 'Freq');
            end
            % Scaling PFreq
            [xname, xdata, xunit] = scalingfrequency(data);
        else
            if ~isa(pout, 'rfdata.power') 
                data = [];
            else
                data = get(pout, 'Pin');
            end
            % Scaling Pin
            [xname, xdata, xunit] = scalingpower(data, format);
        end
    end
    
case 'AMAM/AMPM Parameters'
    if isa(refobj, 'rfdata.reference')
        pout = get(refobj,'PowerData');
        if nargin == 4
            if ~isa(pout, 'rfdata.power') 
                data = [];
            else
                data = get(pout, 'Freq');
            end
            % Scaling PFreq
            [xname, xdata, xunit] = scalingfrequency(data);
        else
            if ~isa(pout, 'rfdata.power') 
                data = [];
            else
                temp = get(pout, 'Pin');
                numtrace = length(temp);
                for k=1:numtrace
                    data{k} = sqrt(4 * 50 * temp{k});
                end
            end
            % Scaling Pin
            [xname, xdata, xunit] = scalingampm(data, format);
        end
    end
otherwise
    id = sprintf('rf:%s:xaxis:InvalidDataType', strrep(class(h),'.',':'));
    error(id, sprintf('Invalid data type: %s.', ptype));
end


function [fname, freq, funit] = scalingfrequency(in)
% Set the defaults
fname = 'Freq';
freq = [];
funit = 'Hz';

if isempty(in); return; end

% Scaling the frequency
if in(end) >= 1e+12
    funit = '[THz]';
    freq = in * 1.e-12;
elseif in(end) >= 1e+9
    funit = '[GHz]';
    freq = in * 1.e-9;
elseif in(end) >= 1e+6
    funit = '[MHz]';
    freq = in * 1.e-6;
elseif in(end) >= 1e+3
    funit = '[KHz]';
    freq = in * 1.e-3;
else
    funit = '[Hz]';
    freq = in;
end


function [pname, pdata, punit] = scalingpower(in, format)
% Set the defaults
pname = '';
pdata = [];
punit = '';

if isempty(in); return; end

% Scalling the power data
numtrace = length(in);
switch format
case 'dBm'
    for k=1:numtrace
        pdata{k} = 10 * log10(in{k}) + 30;
    end
    pname = 'P_{in}';
    punit = '[dBm]';
case 'dBw'
    for k=1:numtrace
        pdata{k} = 10 * log10(in{k});
    end
    pname = 'P_{in}';
    punit = '[dBw]';
case 'mW'
    for k=1:numtrace
        pdata{k} = 1000 * in{k};
    end
    pname = 'P_{in}';
    punit = '[mW]';
case 'W'
    pdata = in;
    pname = 'P_{in}';
    punit = '[W]';
otherwise
    for k=1:numtrace
        pdata{k} = 10 * log10(in{k}) + 30;
    end
    pname = 'P_{in}';
    punit = '[dBm]';
end


function [pname, pdata, punit] = scalingampm(in, format)
% Set the defaults
pname = '';
pdata = [];
punit = '';

if isempty(in); return; end

% Scalling the power data
numtrace = length(in);
switch format
case {'dB' 'Magnitude (decibels)'}
    for k=1:numtrace
        pdata{k} = 20 * log10(in{k});
    end
    pname = 'AM of Input';
    punit = '[dB]';
case {'Mag' 'Magnitude (linear)' 'None'}
    for k=1:numtrace
        pdata{k} = in{k};
    end
    pname = 'AM of Input';
    punit = '';
otherwise
    for k=1:numtrace
        pdata{k} = 20 * log10(in{k});
    end
    pname = 'AM of Input';
    punit = '[dB]';
end


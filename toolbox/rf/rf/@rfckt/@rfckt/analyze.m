function analyze(h, freq)
%ANALYZE Analyze the RFCKT object in frequency domain.
%   ANALYZE(H, FREQ) analyzes the RFCKT object in frequency domain at the
%   given frequencies specified by the input FREQ. The first input is the
%   handle of the RFCKT object to be analyzed, the second input is a vector
%   for the specified freqencies.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.11 $  $Date: 2004/04/20 23:19:39 $

% Get and check the input FREQ 
if nargin < 2
    id = sprintf('rf:%s:analyze:NoInputFreq', strrep(class(h),'.',':'));
    error(id, 'You must provide input frequency as a positive vector.');
end

f = checkfrequency(h, freq);
cflag = get(h, 'Flag');
setflagindexes(h);
% To see if the analysis is needed
if (bitget(cflag, indexOfNeedToUpdate) == 0) 
    oldfreq = data.Freq;
    if length(f) == length(oldfreq)
        if ~any(f-oldfreq);  return;  end;
    end
end

% Create an RFDATA.DATA object if needed
if ~isa(h.RFdata, 'rfdata.data')
    setrfdata(h, rfdata.data);
end
data = get(h, 'RFdata');
z0 = get(data, 'Z0');

% Check the properties of RFCKT object
if bitget(cflag, indexOfThePropertyIsChecked) == 0
    checkproperty(h);
end

% Calculate the network parameters
[type, netparameters, own_z0] = nwa(h, f);

% Calculate the S-parameters
if strncmpi(type,'S',1)
    sparams = s2s(netparameters, own_z0, z0);
else
    sparams = convertmatrix(data, netparameters, type, 'S_PARAMETERS', z0);
end

% Update the properties of RFDATA.DATA object
set(data, 'S_Parameters', sparams, 'Freq', f, 'Z0', z0);

% Calculate noise figure and OIP3
nf = noise(h, f);
ip3 = oip3(h, f);
if isempty(nf);  nf = ones(length(f), 1);  end;
if isempty(ip3);  ip3 = inf * ones(length(f), 1);  end;
set(data, 'NF', nf, 'OIP3', ip3);

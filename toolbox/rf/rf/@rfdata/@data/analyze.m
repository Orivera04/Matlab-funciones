function analyze(h, freq)
%ANALYZE Analyze the data object in frequency domain.
%   ANALYZE(H, FREQ) analyzes the data object in frequency domain at the
%   given frequencies specified by the input FREQ. The first input is the
%   handle of the data object to be analyzed, the second input is a vector
%   for the specified freqencies.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.7 $  $Date: 2004/04/12 23:38:07 $

% Get and check the input FREQ 
if nargin < 2
    id = sprintf('rf:%s:analyze:NoInputFreq', strrep(class(h),'.',':'));
    error(id, 'You must provide input frequency as a positive vector.');
end

f = checkfrequency(h, freq);
checkproperty(h);
if isempty(h.Reference)
    checksparams(h);
end

% Calculate the network parameters 
[type, netparameters, own_z0] = nwa(h, f);

% Update the properties
set(h, 'Freq', f, 'S_Parameters', netparameters, 'Z0', own_z0);

% Calculate noise figure and OIP3
nf = noise(h, f);
if isempty(nf)
    nf = passivenoise(h, f);
end
ip3 = oip3(h, f);
if isempty(nf);  nf = ones(length(f), 1);  end;
if isempty(ip3);  ip3 = inf * ones(length(f), 1);  end;
% Update the properties
set(h, 'NF', nf, 'OIP3', ip3);


function checksparams(h)

sparams = get(h, 'S_Parameters');
freq = get(h, 'Freq');
z0 = get(h, 'Z0');

if isempty(sparams)
     id = 'rf:rfdata:data:analyze:EmptySParams';
     error(id, 'The property: S_Parameters should not be empty.');
end
[m1, m2, m3] = size(sparams);
[n1, n2] = size(freq);
if ~isvector(freq)
     id = 'rf:rfdata:data:analyze:FreqNotValid';
     error(id, 'The property: Freq must be a vector of length M.');
end
if n1 == 1 && n2 >1
    freq = freq';
    [n1, n2] = size(freq);
    set(h, 'Freq', freq);
end
if ~(n1==m3)
     id = 'rf:rfdata:data:analyze:FreqNotValid';
     error(id, 'The property: Freq must be a vector of length M.');
end

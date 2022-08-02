function nf = noise(h, freq)
%NOISE Calculate the noise figure.
%   NF = NOISE(H, FREQ) calculates the noise figure of the circuit object
%   at the specified frequencies FREQ. The first input is the handle to the
%   circuit object, the second input is a vector for the specified
%   freqencies.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.5 $  $Date: 2004/04/12 23:36:09 $

error(nargchk(2,2,nargin))
% Get the data
data = get(h, 'RFdata');
if ~isa(data, 'rfdata.data') || (length(data.Freq) ~= length(freq)) ...
        || any(data.Freq(:) - freq(:))
    analyze(h, freq); 
    nf = h.RFdata.NF;
    return;
end

f = data.Freq;
% Calc the noise figure
nf = noise(data, f);
if isempty(nf)
    nf(1:length(f), 1) = 10 .^ (get(h, 'NF')/10);
end
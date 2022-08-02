function nf = noise(h, freq)
%NOISE Calculate the noise figure.
%   NF = NOISE(H, FREQ) calculates the noise figure of the data object at
%   the specified frequencies FREQ. The first input is the handle to the
%   data object, the second input is a vector for the specified freqencies.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.6 $  $Date: 2004/04/20 23:19:46 $

% Set the default 
nf = [];

error(nargchk(2,2,nargin))
% Get the parameters
f = get(h, 'Freq');
sparams = get(h, 'S_Parameters');
if isempty(sparams) || (length(f) ~= length(freq)) || (any(f(:) - freq(:)))
    analyze(h, freq);
    nf = h.NF;
    return;
end

refobj = get(h, 'Reference');
if isa(refobj, 'rfdata.reference')
    noisedata = get(refobj, 'NoiseData');
    if isa(noisedata, 'rfdata.noise')
        % Get the noise data
        z0 = 50;
        fmin = interpolate(h, noisedata.Freq, noisedata.FMIN, f);
        gammaopt = interpolate(h, noisedata.Freq, noisedata.GAMMAOPT, f);
        rn = interpolate(h, noisedata.Freq, noisedata.RN, f);
        gammas = (h.Zs - z0) ./ (h.Zs + z0);
        % Calc the noise figure
        nf = fmin + 4 * rn .* (abs(gammas - gammaopt) .^ 2) ./ ...
            (1 - abs(gammas) .^ 2) ./ (abs(1 + gammaopt) .^ 2);
        % Analysis and Design, (4.3.4) p299
    end
end

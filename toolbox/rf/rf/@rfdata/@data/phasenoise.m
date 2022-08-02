function phasenoiselevel = phasenoise(h, freqoffset)
%PHASENOISE Calculate the phase noise.
%   PHASENOISELEVEL = PHASENOISE(H, FREQOFFSET) calculates the phase noise
%   of the mixer's data object at the specified frequencies offset
%   FREQOFFSET. The first input is the handle to the data object, the
%   second input is a vector for the specified freqency offset.

%   Copyright 2004 The MathWorks, Inc. 
%   $Revision: 1.1.6.3 $  $Date: 2004/03/24 20:45:38 $

phasenoiselevel = [];
% Get the data
original_freqoffset = h.FreqOffset;
original_phasenoiselevel = h.PhaseNoiseLevel;

% Calculate the phase noise level
if ~isempty(original_phasenoiselevel) && ~isempty(original_freqoffset)
    method = get(h, 'IntpType');
    set(h, 'IntpType', 'linear');
    phasenoiselevel = interpolate(h, log10(original_freqoffset), ...
        original_phasenoiselevel, log10(freqoffset));
    set(h, 'IntpType', method);
end

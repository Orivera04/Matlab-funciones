function checkproperty(h)
%CHECKPROPERTY Check the properties of the object.
%   CHECKPROPERTY(H) checks the properties of the object.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:37:13 $

checkbaseproperty(h);

% Set the flag for nonlinear
cflag = get(h, 'Flag');
setflagindexes(h);
if bitget(cflag, indexOfNonLinear) == 0
    % Check the IP3
    if ~((get(h, 'IIP3') == inf) && (get(h, 'OIP3') == inf))
        updateflag(h, indexOfNonLinear, 1, MaxNumberOfFlags);
    end
end
% Check phase noise
if ~isa(h.RFdata, 'rfdata.data')
    setrfdata(h, rfdata.data);
end
data = get(h, 'RFdata');
freqoffset = h.FreqOffset;
phasenoiselevel = h.PhaseNoiseLevel;
if ~isempty(freqoffset) && ~isempty(phasenoiselevel)
    if (length(phasenoiselevel) ~= length(freqoffset))
        id = sprintf('rf:%s:checkproperty:WrongPhaseNoise', strrep(class(h),'.',':'));
        error(id, 'Phase noise frequency offset and magnitude must be of same length.'); 
    end
    [freqoffset, findex] = sort(freqoffset);
    phasenoiselevel(:) = phasenoiselevel(findex);
    n = length(freqoffset);
    set(data, 'FreqOffset', [0.5 * freqoffset(1) freqoffset(1:n)' 1.5 * freqoffset(n)], ...
        'PhaseNoiseLevel', [phasenoiselevel(1) phasenoiselevel(1:n)' phasenoiselevel(n)]);
else
    set(data, 'FreqOffset', [], 'PhaseNoiseLevel', []);
end

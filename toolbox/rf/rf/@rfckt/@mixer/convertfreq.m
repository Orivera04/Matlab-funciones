function out = convertfreq(h, in)
%CONVERTFREQ Convert the input frequency to get the output frequency.
%    OUTPUT = CONVERTFREQ(h, input) Convert the input frequency to
%    get the output frequency.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.5 $  $Date: 2004/04/12 23:37:14 $

switch lower(h.MixerType)
case 'downconverter'
    out = in - h.FLO;
case 'upconverter'
    out = in + h.FLO;
end
if any (out < 0)
    id = sprintf('rf:%s:convertfreq:MixerNegativeOutFrequency', ...
        strrep(class(h),'.',':'));
    error(id, 'Mixer output frequency is negative. %s', ...
        'Check FLO of MIXER and the simulation frequency.');
end

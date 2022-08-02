function valsamp = manchesterencoder(phaseerr)
% MANCHESTERENCODER  Generates manchester encoded data stream
%   [V,S] = MANCHESTERENCODER(PERR) - Repeated calls to this 
%   function will return a stream of binary samples from a
%   random manchester-encoded waveform.  The sample period
%   is nominally 1/16th of the data (baud) period.  PERR defines
%   a phase offset from the nominal sample period.  This phase
%   error is scaled such that 1 equals a full baud period.  PERR 
%   is applied to each sample and therefore can emulate a 
%   frequency offset if PERR is a constant value > 0 for every 
%   invocation.
%
%  Return values    
%    V = Unencoded binary value (randomly selected)
%    S = Manchester encoded version of V
%  
%   Copyright 2003 The MathWorks, Inc.
%   $Revision: 1.2 $  $Date: 2003/07/15 15:42:52 $
%
persistent phase;
persistent value;

if isempty(phase),
    phase = 0;
    value = (rand > 0.5);  % first binary 
end

phase = phase + phaseerr + 1/16;
if phase >= 1, % wrap 
    value = (rand > 0.5);  % next binary 
    phase = phase - floor(phase);
end
if phase < 0.5,
    valsamp = double([value value]);
else
    valsamp = double([value ~value]);
end

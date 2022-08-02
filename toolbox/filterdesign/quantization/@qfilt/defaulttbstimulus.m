function stimcell = defaulttbstimulus(filtobj)
%DEFAULTTBSTIMULUS Default Test Bench Stimulus.

%   Author(s): P. Costa
%   Copyright 2003 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $  $Date: 2003/04/11 18:20:27 $

stimcell = {'impulse','step','ramp','chirp','noise'};
if ~isfir(filtobj),
    stimcell = {'step','ramp','chirp'};
end

% [EOF]

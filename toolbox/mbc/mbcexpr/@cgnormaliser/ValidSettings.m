function out = ValidSettings(N,BP,V)
%VALIDSETTINGS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:13:41 $

% NORMALISER/VALIDSETTINGS :: Returns 0 if BP and V could be the breakpoints and values for a valid 
% normaliser.

% OK they are fine if they define an increasing function, which

out = 1;

if ~isequal(size(BP),size(V)) % Not same size then no good
    out = 0;
    return
end

dbp = sign(diff(BP)); % Make sure breakpoints are increasing
if any(dbp(:)<0)| all(dbp(:)==0)
    out = 0;
    return
end

dv = sign(diff(V)); % Do same for values
if any(dv(:)<0) | all(dv(:)==0)
    out = 0;
    return
end

return
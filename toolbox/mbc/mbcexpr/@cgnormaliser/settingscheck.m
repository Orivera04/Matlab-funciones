function [OK,msg] = settingscheck(N)
% CGNORMALISER/SETTINGSCHECK :: Perform a brief diagnostic to see whether we can evaluate this normaliser or not

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.



%   $Revision: 1.9.2.2 $  $Date: 2004/02/09 07:14:20 $

% So we want to check for increasing breakpoints

OK = 1; msg = ''; % Inital settings, assume everything will be OK.

BP = N.Breakpoints;
Val = N.Values;
if isempty(BP) | isempty(Val)
    OK = 0;
    msg = ['The normalizer ', getname(N),' needs to be set up, please go to the Calibration Manager to do this'];
end

dBP = diff(BP);

if any(dBP(:)<0)
    OK = 0; 
    msg = [msg, 'The breakpoints of ',getname(N),...
            ' are not increasing. Please adjust them using the manual editing tools in the normalizer view.'];
end

return
    

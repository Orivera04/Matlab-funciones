function [OK,msg] = settingscheck(T)
% CGNORMFUNCTION/SETTINGSCHECK :: Perform a brief diagnostic to see whether we can evaluate this normaliser or not

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.



%   $Revision: 1.9.2.2 $  $Date: 2004/02/09 07:15:10 $

% So we want to check for increasing breakpoints

OK = 1; msg = ''; % Inital settings, assume everything will be OK.

Val = T.Values;

if isempty(Val)
    OK = 0;
    msg = ['The table ', getname(T),' needs to be set up, please go to the Calibration Manager to do this'];
end

xNormaliser = T.Xexpr;

if isempty(xNormaliser) 
    OK = 0;
    msg = [msg,' The table ', getname(T) ,...
            ' does not have its normalizers set up. Please set them up using the strategy editor in the feature view.'];
end

[tempOK,tempmsg] = settingscheck(xNormaliser.info);
OK = tempOK*OK;
msg = [msg,' ' , tempmsg];

return
    

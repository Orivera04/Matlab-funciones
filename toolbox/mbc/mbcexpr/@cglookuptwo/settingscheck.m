function [OK,msg] = settingscheck(T)
% CGLOOKUPTWO/SETTINGSCHECK :: Perform a brief diagnostic to see whether we can evaluate this normaliser or not

% So we want to check for increasing breakpoints

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.



%   $Revision: 1.7.2.2 $  $Date: 2004/02/09 07:12:40 $

OK = 1; msg = ''; % Inital settings, assume everything will be OK.

Val = T.Values;

if isempty(Val)
    OK = 0;
    msg = ['The table ', getname(T),' needs to be set up, please go to the Calibration Manager to do this'];
end

xNormaliser = T.Xexpr;
yNormaliser = T.Yexpr;

if isempty(xNormaliser) | isempty(yNormaliser)
    OK = 0;
    msg = [msg,' The table ', getname(T) ,...
            ' does not have its normalizers set up. Please set them up using the equation editor in the feature view.'];
end

[tempOK,tempmsg] = settingscheck(xNormaliser.info);
OK = tempOK*OK;
msg = [msg,' ' , tempmsg];

[tempOK,tempmsg] = settingscheck(yNormaliser.info);
OK = tempOK*OK;
msg = [msg,' ' , tempmsg];

return
    
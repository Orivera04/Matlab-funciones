function parametercallback(DummyEF, FrameTag);

% function parametercallback(DummyEF, FrameTag);
% 
% Callback function for parameter controls within evalfunctions object.
% FrameTag is used to access the UserData property of the GUO frame.
% DummyEF is required by MATLAB and will be deleted.
%
% Copyright (c) SINUS Messtechnik GmbH 2003
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

UserData = getuserdata(DummyEF, FrameTag);
evaltooltips(UserData, {get(gcbo, 'Tag')});
delete(DummyEF);

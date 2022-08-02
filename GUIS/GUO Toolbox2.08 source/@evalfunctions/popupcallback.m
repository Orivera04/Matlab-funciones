function popupcallback(DummyEF, FrameTag);

% function popupcallback(DummyEF, FrameTag);
% 
% Callback function for PopupMenu control within evalfunctions object.
% FrameTag is used to access the UserData property of the GUO frame.
% DummyEF is required by MATLAB and will be deleted.
%
% Copyright (c) SINUS Messtechnik GmbH 2003
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

setpopupfunction(DummyEF, FrameTag, get(gcbo, 'Value'));
delete(DummyEF);

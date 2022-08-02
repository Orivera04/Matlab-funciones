function EF = selectcurrentfunction(EF, FunctionNumber);

% function EF = selectcurrentfunction(EF, FunctionNumber);
% 
% Selects function in PopupMenu control within evalfunctions object.
%
% Copyright (c) SINUS Messtechnik GmbH 2003
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

EF = setchild(EF, 'EF_Popup', 'Value', FunctionNumber);
FrameTag = get(EF, 'Tag');
setpopupfunction(EF, FrameTag, FunctionNumber);

function [nObjects, nGUOs] = nchildren(GUO);

% function [nObjects, nGUOs]  = nchildren(GUO);
% 
% Returns the number of children within "GUO".
% "nObjects" is the number of child objects (uicontrols and axes) and "nGUOs" 
% is the number of child GUOs within "GUO".
%
% Copyright (c) SINUS Messtechnik GmbH 2002
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

if ~ishandle(GUO.Frame)
   error('Object (GUO frame) has been deleted');
end
nObjects = length(GUO.Children);
nGUOs = length(GUO.ChildGUOs);

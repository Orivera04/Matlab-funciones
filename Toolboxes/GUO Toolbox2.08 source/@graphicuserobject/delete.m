function GUO = delete(GUO);

% function GUO = delete(GUO);
% 
% Deletes the GUO frame, child objects and child GUOs of "GUO".
%
% Copyright (c) SINUS Messtechnik GmbH 2002
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

if ~ishandle(GUO.Frame)
   warning('Object (GUO frame) has already been deleted');
   return
end
[n, nGUOs] = nchildren(GUO);
for k = nGUOs:-1:1
   GUO = deletechildguo(GUO, k);
end
for k = n:-1:1
   GUO = deletechild(GUO, k);
end
delete(GUO.Frame);

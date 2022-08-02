function GUO = deletechildguo(GUO, ChildGUO);

% function GUO = deletechildguo(GUO, ChildGUO);
% 
% Deletes "ChildGUO" from "GUO".
% "ChildGUO" may be a Tag name or a child GUO number (see "addchildguo").
%
% Copyright (c) SINUS Messtechnik GmbH 2002-2003
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

if ~ishandle(GUO.Frame)
   error('Object (GUO frame) has been deleted');
end
nChildGUOs = length(GUO.ChildGUOs);
if ischar(ChildGUO)
   ChildTag = ChildGUO;
   ChildGUO = 0;
   for k = 1:nChildGUOs
      if strcmpi(get(GUO.ChildGUOs{k}, 'Tag'), ChildTag)
         ChildGUO = k;
         break;
      end
   end
end
if ChildGUO > 0 & ChildGUO <= nChildGUOs
   delete(GUO.ChildGUOs{ChildGUO});
   GUO.ChildGUOs = {GUO.ChildGUOs{1:ChildGUO-1} GUO.ChildGUOs{ChildGUO+1:end}};
end

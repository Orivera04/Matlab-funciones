function GUO = deletechild(GUO, Child);

% function GUO = deletechild(GUO, Child);
% 
% Deletes GUO child object;  "Child" may be a Tag name or the number of the 
% child object (see "uicontrol").
%
% Copyright (c) SINUS Messtechnik GmbH 2002
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

if ~ishandle(GUO.Frame)
   error('Object (GUO frame) has been deleted');
end
if ischar(Child)
   ChildHandle = findobj(GUO.Children, 'Tag', Child);
else
   ChildHandle = GUO.Children(Child);
end
if ishandle(ChildHandle)
   Index = find(GUO.Children == ChildHandle);
   delete(ChildHandle);
   GUO.Children = [GUO.Children(1:Index-1) GUO.Children(Index+1:end)];
else
   error('Child not found')
end

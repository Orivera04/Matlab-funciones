function T = deletechildguo(T, ChildGUO);

% function T = deletechildguo(T, ChildGUO);
% 
% Deletes a (child) graphicuserobject and its corresponding tab button from a tabobject.
% "ChildGUO" may be a Tag name or a child GUO number.
%
% Copyright (c) SINUS Messtechnik GmbH 2002-2003
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

[n, nChildGUOs] = nchildren(T);  % Note: normally, n == nChildGUOs + 1 (see addchildguo.m)
ChildGUO = getchildguoindex(T, ChildGUO);
if ChildGUO < 1 | ChildGUO > nChildGUOs
   error('deletechildguo:  ChildGUO out of range or not found');
else
   P = getchild(T, ChildGUO, 'Position');
   ButtonWidth = P(3);
   T = deletechild(T, ChildGUO);  % delete tab button
   for k = ChildGUO:nChildGUOs-1  % fill the gap between the tab buttons
      P = getchild(T, k, 'Position');
      P(1) = P(1) - ButtonWidth;
      setchild(T, k, 'Position', P);
   end
   T.graphicuserobject = deletechildguo(T.graphicuserobject, ChildGUO);  % delete child GUO
   if ChildGUO == nChildGUOs  % set current tab
      ChildGUO = ChildGUO - 1;
   end
   T.CurrentTab = 0;  % avoids unnecessary "hide"
   T = selectchildguo(T, ChildGUO);
end

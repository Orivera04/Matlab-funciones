function T = selectchildguo(T, ChildGUO);

% function T = selectchildguo(T, ChildGUO);
% 
% Selects a (child) graphicuserobject and its corresponding tab button within a tabobject.
% "ChildGUO" may be a Tag name or a child GUO number.
%
% Copyright (c) SINUS Messtechnik GmbH 2002-2003
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

ChildGUO = getchildguoindex(T, ChildGUO);
if T.CurrentTab ~= ChildGUO
   if ChildGUO > 0
      JumpWidth = 0.005;
      if T.CurrentTab > 0
         T = guoeval(T, T.CurrentTab, 'hide');
         PB = getchild(T, T.CurrentTab, 'Position');
         PB(4) = PB(4) - T.JumpHeight;  % decrease size of tab button (see below)
         PB(1) = PB(1) + JumpWidth;
         PB(3) = PB(3) - JumpWidth;
         T = setchild(T, T.CurrentTab, 'Position', PB);
      end
      % The last control in T is a text control which is used to blank
      % out the lower edge of the active tab button - see addchildguo.m
      n = nchildren(T);
      PB = getchild(T, ChildGUO, 'Position');
      PB(4) = PB(4) + T.JumpHeight;  % increase size of tab button slightly
      PB(1) = PB(1) - JumpWidth;
      PB(3) = PB(3) + JumpWidth;
      T = setchild(T, ChildGUO, 'Position', PB);
      PT = getchild(T, n, 'Position');
      PT(1) = PB(1) + 0.001;  % Set X & width almost the same as tab button
      PT(3) = PB(3) - 0.002;
      T = setchild(T, n, 'Position', PT);
      T = guoeval(T, ChildGUO, 'show');
   end
   T.CurrentTab = ChildGUO;
end

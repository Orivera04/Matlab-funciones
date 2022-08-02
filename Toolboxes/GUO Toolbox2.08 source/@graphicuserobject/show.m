function [GUO, WasHidden] = show(GUO);

% function [GUO, WasHidden] = show(GUO);
% 
% Makes "GUO" (if previously hidden) visible again.  The Visible property is
% set to its previous value for all objects affected by the "hide" function. 
% "WasHidden" indicates whether "GUO" was already hidden.
%
% Copyright (c) SINUS Messtechnik GmbH 2002-2003
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

WasHidden = GUO.Hidden;
if GUO.Hidden
   if ~ishandle(GUO.Frame)
      warning('Object (GUO frame) has been deleted');
      return
   end
   % GUO frame (axes)
   set(GUO.Frame, 'Visible', GUO.HiddenFrameWasVisible);
   % Children of GUO frame (axes), e.g. text and rectangle objects
   set(GUO.FrameChildren, {'Visible'}, GUO.FrameChildWasVisible);
   % Children of GUO (uicontrols and axes)
   set(GUO.Children, {'Visible'}, GUO.HiddenChildWasVisible);
   % Children of children of GUO, e.g. text and rectangle objects within axes children
   n = length(GUO.Children);
   for k = 1:n
      set(GUO.HiddenGrandchildren{k}, {'Visible'}, GUO.HiddenGrandchildWasVisible{k});
   end
   % Child GUOs (recursion)
   n = length(GUO.ChildGUOs);
   for k = 1:n
      if ~GUO.ChildGUOWasHidden(k)
         GUO.ChildGUOs{k} = show(GUO.ChildGUOs{k});
      end
   end
   GUO.Hidden = 0;
end

function [GUO, WasHidden] = hide(GUO);

% function [GUO, WasHidden] = hide(GUO);
% 
% Makes "GUO" invisible.  The Visible property is set to 'off' for the GUO
% frame (axes) and the children (uicontrols and axes) of "GUO", as well as for
% all children (e.g. text and rectangle objects) of the various axes.  The
% previous status of the Visible property for each of these objects is saved
% so that it can be restored by the "show" function.  The "hide" function
% applies itself recursively to the child GUOs. 
% "WasHidden" indicates whether "GUO" was already hidden.
%
% Copyright (c) SINUS Messtechnik GmbH 2002-2003
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

WasHidden = GUO.Hidden;
if ~GUO.Hidden
   if ~ishandle(GUO.Frame)
      warning('Object (GUO frame) has been deleted');
      return
   end
   % GUO frame (axes)
   GUO.HiddenFrameWasVisible = get(GUO.Frame, 'Visible');
   set(GUO.Frame, 'Visible', 'off');
   % Children of GUO frame (axes), e.g. text and rectangle objects
   GUO.FrameChildren = get(GUO.Frame, 'Children');
   switch length(GUO.FrameChildren)
   case 0
      GUO.FrameChildWasVisible = {};
   case 1
      GUO.FrameChildWasVisible = {get(GUO.FrameChildren, 'Visible')};
   otherwise
      GUO.FrameChildWasVisible = get(GUO.FrameChildren, 'Visible');
   end
   set(GUO.FrameChildren, 'Visible', 'off');
   % Children of GUO (uicontrols and axes)
   switch length(GUO.Children)
   case 0
      GUO.HiddenChildWasVisible = {};
   case 1
      GUO.HiddenChildWasVisible = {get(GUO.Children, 'Visible')};
   otherwise
      GUO.HiddenChildWasVisible = get(GUO.Children, 'Visible');
   end
   set(GUO.Children, 'Visible', 'off');
   % Children of children of GUO, e.g. text and rectangle objects within axes children
   n = length(GUO.Children);
   for k = 1:n
      h = GUO.Children(k);             % Handle of Child
      hChildren = get(h, 'Children');  % Handles of "Grandchildren"
      switch length(hChildren)
      case 0
         GUO.HiddenGrandchildWasVisible{k} = {};
      case 1
         GUO.HiddenGrandchildWasVisible{k} = {get(hChildren, 'Visible')};
      otherwise
         GUO.HiddenGrandchildWasVisible{k} = get(hChildren, 'Visible');
      end
      set(hChildren, 'Visible', 'off');
      GUO.HiddenGrandchildren{k} = hChildren;
   end
   % Child GUOs (recursion)
   n = length(GUO.ChildGUOs);
   for k = 1:n
      [GUO.ChildGUOs{k}, GUO.ChildGUOWasHidden(k)] = hide(GUO.ChildGUOs{k});
   end
   GUO.Hidden = 1;
end

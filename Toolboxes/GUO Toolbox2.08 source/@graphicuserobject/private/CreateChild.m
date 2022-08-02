function GUO = CreateChild(GUO, ChildType, varargin);

% function GUO = CreateChild(GUO, ChildType, varargin);
% 
% Creates a child object within graphicuserobject.  ChildType may be
% either 'axes' or 'uicontrol'.  The argument list varargin is as
% for the appropriate standard MATLAB creation function except that
% GUO is supplied instead of "parent".  Child objects are positioned
% relative to the GUO frame, and sized relative to the frame if the
% Units property of the object is 'normalized' (the default here), in
% which case the object is set (internally) to the GUO frame's units. 
% Specifying the Tag property for the child object allows it to be
% referenced by name, otherwise it can only be referenced by number.
%
% Copyright (c) SINUS Messtechnik GmbH 2002
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

if ~ishandle(GUO.Frame)
   error('Object (GUO frame) has been deleted');
end
FrameParent = get(GUO.Frame, 'Parent');
ChildArgs = varargin;
% Create object with Visible=off to avoid flicker when
% positioning, unless the Visible property is supplied.
VisiblePropertyFound = FindProperty('Visible', varargin);
if ~VisiblePropertyFound
   ChildArgs = [{'Visible', 'off'}, ChildArgs];
end
if ~FindProperty('Units', varargin)
   ChildArgs = [{'Units', 'normalized'}, ChildArgs];
end
switch ChildType
case 'axes'
   if ~FindProperty('NextPlot', varargin)
      ChildArgs = [{'NextPlot', 'replacechildren'}, ChildArgs];
   end  % avoid reset of axes properties (e.g. Tag) by plot function etc.
   figure(FrameParent);  % axes created in the current figure
   ChildHandle = axes(ChildArgs{:});
otherwise  % 'uicontrol'
   ChildArgs = [{FrameParent}, ChildArgs];
   ChildHandle = uicontrol(ChildArgs{:});
end
GUO.Children = [GUO.Children ChildHandle];
Index = length(GUO.Children);
% Position/size child relative to GUO frame
GUO = PositionInFrame(GUO, ChildHandle, Index);
if ~VisiblePropertyFound
   set(ChildHandle, 'Visible', 'on');
end

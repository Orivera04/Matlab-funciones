function valOrGUO = setchild(GUO, Child, varargin);

% function valOrGUO = setchild(GUO, Child, varargin);
% 
% Sets properties for GUO child object;  "Child" may be a Tag name or the number
% of the child object (see "uicontrol").  The return value valOrGUO must be
% assigned to the GUO in all cases except where the MATLAB set function would 
% return a result (property information - see MATLAB help).
%
% Copyright (c) SINUS Messtechnik GmbH 2002
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

if ~ishandle(GUO.Frame)
   error('Object (GUO frame) has been deleted');
end
if FindProperty('Parent', varargin)
   error('Parent property may not be set for Child objects');
end
if ischar(Child)
   ChildHandle = findobj(GUO.Children, 'Tag', Child);
   Index = find(GUO.Children == ChildHandle);
else
   Index = Child;
   ChildHandle = GUO.Children(Index);
end
if ishandle(ChildHandle)
   ChildArgs = [{ChildHandle}, varargin];
   % Modify control with Visible=off to avoid flicker when
   % positioning, unless the Visible property is supplied.
   VisiblePropertyFound = FindProperty('Visible', varargin);
   if ~VisiblePropertyFound
      ChildArgs = [ChildArgs, {'Visible', 'off'}];
   end
   try  % try/catch necessary in MATLAB R13 because of error "One or more output arguments not assigned during call to 'set'"
       warning off;  % Suppress warning in R12 when the "set" function doesn't deliver a result (normal case!)
       valOrGUO = set(ChildArgs{:});
       warning on;
   catch
       set(ChildArgs{:});
   end
   if ~exist('valOrGUO')
      if FindProperty('Position', varargin)
         % Position/size child relative to GUO frame
         GUO = PositionInFrame(GUO, ChildHandle, Index);
      elseif FindProperty('Units', varargin)
         NC = strcmpi(get(ChildHandle, 'Units'), 'normalized');
         GUO.NormalizedChildren(Index) = NC;
         if NC
            set(ChildHandle, 'Units', get(GUO.Frame, 'Units'));
         end
      end
      if ~VisiblePropertyFound
         set(ChildHandle, 'Visible', 'on');
      end
      valOrGUO = GUO;
   end
else
   error('Child not found')
   valOrGUO = GUO;
end
 
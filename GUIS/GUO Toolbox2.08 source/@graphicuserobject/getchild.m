function var = getchild(GUO, Child, varargin);

% function var = getChild(GUO, Child, varargin);
% 
% Gets properties of GUO child object;  "Child" may be a Tag name or the number
% of the child object (see "uicontrol").
%
% Copyright (c) SINUS Messtechnik GmbH 2002
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

if ~ishandle(GUO.Frame)
   error('Object (GUO frame) has been deleted');
end
try
   if ischar(Child)
      ChildHandle = findobj(GUO.Children, 'Tag', Child);
      Child = find(GUO.Children == ChildHandle);
   else
      ChildHandle = GUO.Children(Child);
   end
   if ishandle(ChildHandle)
      var = get(ChildHandle, varargin{:});
      if GUO.NormalizedChildren(Child) & nargin > 2
         Property = lower(deblank(varargin{1}));
         switch Property
         case {'position', 'extent'}  % Return Position/Extent normalized to GUO Frame
            FramePos = get(GUO.Frame, 'Position');
            var = var - [FramePos(1:2) 0 0];
            var = var ./ [FramePos(3:4) FramePos(3:4)];
         end
      end
   else
      error('Child not found');
   end
catch
   error('Child not found');
end

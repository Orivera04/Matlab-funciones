function GUO = axes(GUO, varargin);

% function GUO = axes(GUO, varargin);
% 
% Creates or makes current a child axes object within "GUO".  To create a child
% axes object, the argument list "varargin" is as for the standard MATLAB axes
% function (i.e. property name/value pairs);  positioning and referencing is
% performed as described in "uicontrol".  To make an axes object (either a
% child or the GUO frame) the current axes, "varargin" must have exactly one
% element referencing the axes by name or number;  to make the GUO frame the
% current axes, the element may be supplied as empty, zero or the Tag of the
% GUO frame.
%
% Copyright (c) SINUS Messtechnik GmbH 2002
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

if nargin == 2
   try
      if isempty(varargin) | isempty(varargin{1}) | varargin{1} == 0
         ChildHandle = GUO.Frame;
      elseif ischar(varargin{1})
         ChildHandle = findobj(GUO.Children, 'Tag', varargin{1});
      else
         ChildHandle = GUO.Children(varargin{1});
      end
      if ishandle(ChildHandle)
         if gca ~= ChildHandle
            axes(ChildHandle);
         end
      else
         error('Axes not found');
      end
   catch
      error('Axes not found');
   end
else
   GUO = CreateChild(GUO, 'axes', varargin{:});
end

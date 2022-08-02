function GUO = uicontrol(GUO, varargin);

% function GUO = uicontrol(GUO, varargin);
% 
% Creates a child control within "GUO".  The argument list "varargin" is as for
% the standard MATLAB uicontrol function except that "GUO" is supplied instead
% of "parent".  Child controls are positioned relative to the GUO frame, and
% sized relative to the GUO frame if the Units property of the control is
% 'normalized' (the default here), in which case the control is set (internally)
% to the GUO frame's units.  Specifying the Tag property for the child control
% allows it to be referenced by name;  child controls (and child axes) may also
% be referenced by number (in order of their creation, starting with 1).
%
% Copyright (c) SINUS Messtechnik GmbH 2002
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

GUO = CreateChild(GUO, 'uicontrol', varargin{:});

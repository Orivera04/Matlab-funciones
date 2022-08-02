function val = get(GUO, varargin);

% function val = get(GUO, varargin);
% 
% Gets GUO frame (axes) properties of "GUO".  The "val" and "varargin" arguments
% are as for the standard MATLAB "get" function.
%
% Copyright (c) SINUS Messtechnik GmbH 2002
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

if ~ishandle(GUO.Frame)
   error('Object (GUO frame) has been deleted');
end
val = get(GUO.Frame, varargin{:});

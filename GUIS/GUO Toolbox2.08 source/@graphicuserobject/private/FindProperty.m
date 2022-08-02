function PropertyFound = FindProperty(DesiredProperty, varargin);

% function PropertyFound = FindProperty(DesiredProperty, varargin);
% 
% Find DesiredProperty in property list varargin.
%
% Copyright (c) SINUS Messtechnik GmbH 2002
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

PropertyFound = 0;
Args = varargin{:};
nArgs = length(Args);
for k = 1:2:nArgs
   CurrentArg = Args{k};
   if ischar(CurrentArg) & strcmpi(CurrentArg, DesiredProperty)
      PropertyFound = 1;
      break;
   end
end

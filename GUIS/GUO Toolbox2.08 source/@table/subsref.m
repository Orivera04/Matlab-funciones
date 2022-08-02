function val = subsref(T, index);

% function val = subsref(T, index);
% 
% Defines cell reference (indexing) for table objects (see MATLAB help).
%
% Copyright (c) SINUS Messtechnik GmbH 2002
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

switch index.type
case {'{}', '()'}
   UserData = get(T, 'UserData');
   val = UserData.Data(index.subs{:});
otherwise  % case '.'
   error('Indexing by name is not supported by table object')
end

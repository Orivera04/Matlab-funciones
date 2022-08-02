function SetDir(FS, PathName, Mask);

% function SetDir(FS, PathName, Mask);
% 
% Sets the directory currently shown in the PopupMenu object.
% Mask is optional (remains unchanged if not supplied);
% PathName remains unchanged if supplied as empty string.
%
% Copyright (c) SINUS Messtechnik GmbH 2002
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

UserData = get(FS, 'UserData');
if isempty(PathName)
   PathName = UserData.Directory;
else
   UserData.Directory = PathName;
end
if nargin < 3 | isempty(Mask)
   Mask = UserData.Mask;
else
   UserData.Mask = Mask;
end
set(FS, 'UserData', UserData);

DirStruct = dir(fullfile(PathName, Mask));
PopupString = {DirStruct.name};
PopupString = PopupString(~[DirStruct.isdir]);
if length(PopupString) == 0
   PopupString = {' '};
end
setchild(FS, 'Select', 'String', PopupString);
setchild(FS, 'Select', 'Value',  1);
eval(get(UserData.SelectHandle, 'Callback'));

function FileName = GetFileName(FS);

% function FileName = GetFileName(FS);
% 
% Returns the full file name currently selected in the PopupMenu object.
%
% Copyright (c) SINUS Messtechnik GmbH 2002
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

UserData = get(FS, 'UserData');
PathName = UserData.Directory;
PopupValue = getchild(FS, 'Select', 'Value');
PopupString = getchild(FS, 'Select', 'String');
if PopupValue == 0 | (length(PopupString) == 1 & strcmpi(PopupString, ' '))
   DirStruct = dir(fullfile(PathName, UserData.Mask));
   PopupString = {DirStruct.name};
   PopupString = PopupString(~[DirStruct.isdir]);
   if length(PopupString) == 0
      PopupString = {' '};
   end
   PopupValue = 1;
   setchild(FS, 'Select', 'String', PopupString);
   setchild(FS, 'Select', 'Value',  PopupValue);
end
if ~iscellstr(PopupString)
   PopupString = {PopupString};
end
FileName = [];
if PopupValue > 0 & PopupValue <= length(PopupString)
   FileName = deblank(PopupString{PopupValue});
   if ~isempty(FileName)
      FileName = fullfile(PathName, FileName);
   end
end

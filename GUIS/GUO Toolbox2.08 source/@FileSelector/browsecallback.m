function browsecallback(DummyFS, FrameTag);

% function browsecallback(DummyFS, FrameTag);
% 
% Callback function for Browse button within FileSelector object.
% FrameTag is used to access the UserData property of the GUO frame.
% DummyFS is required by MATLAB and will be deleted.
%
% Copyright (c) SINUS Messtechnik GmbH 2002
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

UserData = getuserdata(DummyFS, FrameTag);
[FileName, PathName] = uigetfile(fullfile(UserData.Directory, UserData.Mask));
if length(FileName) + length(PathName) > 2
   UserData.Directory = PathName;
   DirStruct = dir(fullfile(PathName, UserData.Mask));
   PopupString = {DirStruct.name};
   PopupString = PopupString(~[DirStruct.isdir]);
   if length(PopupString) == 0
      PopupString = {' '};
      PopupValue = 1;
   else
      PopupValue = strmatch(FileName, PopupString, 'exact');
      if PopupValue < 1 | PopupValue > length(PopupString)
         PopupValue = 1;
      end
   end
   set(UserData.SelectHandle, 'String', PopupString);
   set(UserData.SelectHandle, 'Value',  PopupValue);
   setuserdata(DummyFS, FrameTag, UserData);
   eval(get(UserData.SelectHandle, 'Callback'));
end
delete(DummyFS);

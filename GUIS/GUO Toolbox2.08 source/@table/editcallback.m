function editcallback(DummyTable, FrameTag, Row, Column);

% function editcallback(DummyTable, FrameTag, Row, Column);
% 
% Callback function for edit controls within table object.
% FrameTag is used to access the UserData property of the GUO frame.
% The control's Row and Column are built into its callback string.
% DummyTable is required by MATLAB and will be deleted.
%
% Copyright (c) SINUS Messtechnik GmbH 2002
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

NewValue = get(gcbo, 'String');
UserData = getuserdata(DummyTable, FrameTag);
try
	UserData.Data(UserData.CurrentRow + Row - 1, ...
                 UserData.CurrentColumn + Column - 1) = NewValue;
catch
   % Error "??? Conversion to cell from char is not possible."
   % when inserting value into empty cell - note "{NewValue}"!
	UserData.Data(UserData.CurrentRow + Row - 1, ...
                 UserData.CurrentColumn + Column - 1) = {NewValue};
end
setuserdata(DummyTable, FrameTag, UserData);
delete(DummyTable);

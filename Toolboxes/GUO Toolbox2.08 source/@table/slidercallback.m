function slidercallback(DummyTable, FrameTag);

% function slidercallback(DummyTable, FrameTag);
% 
% Callback function for slider controls within table object.
% FrameTag is used to access the UserData property of the GUO frame.
% DummyTable is required by MATLAB and will be deleted.
%
% Copyright (c) SINUS Messtechnik GmbH 2002
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

SliderTag = get(gcbo, 'Tag');
SliderValue = round(get(gcbo, 'Value'));
UserData = getuserdata(DummyTable, FrameTag);
switch SliderTag
case 'VerticalSlider'
   [RowSize, ColSize] = size(UserData.Data);
   UserData.CurrentRow = RowSize + 1 - SliderValue;
case 'HorizontalSlider'
   UserData.CurrentColumn = SliderValue;
otherwise
   error(['SliderTag ''' SliderTag ''' not recognized.']);
end
T = scroll(DummyTable, UserData.CurrentRow, UserData.CurrentColumn, FrameTag, UserData);
delete(DummyTable);

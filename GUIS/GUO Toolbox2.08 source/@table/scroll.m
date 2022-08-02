function T = scroll(T, Row, Column, FrameTag, UserData);

% function T = scroll(T, Row, Column, FrameTag, UserData);
% 
% Scrolls table object T so that the desired Row & Column is in the upper
% left corner.  If Row & Column are not supplied, they default to their
% current values (initially 1) and the function simply refreshes the
% display from the stored table data.  FrameTag is used to access the
% UserData property of the GUO frame because no table object is
% available in callback functions (e.g. slidercallback); if FrameTag
% is empty or not supplied, it is obtained from the table object T.
% UserData should not normally be supplied:  it is purely an
% optimization for when the data is already available, e.g. in the
% subsasgn function.
%
% Copyright (c) SINUS Messtechnik GmbH 2002
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

if nargin < 4
   FrameTag = '';
   if nargin < 3
      Column = UserData.CurrentColumn;
      if nargin < 2
         Row = UserData.CurrentRow;
      end
   end
end
if isempty(FrameTag)
   FrameTag = get(T, 'Tag');
end
if nargin < 5
   UserData = getuserdata(T, FrameTag);
end
UserData.CurrentRow = Row;
UserData.CurrentColumn = Column;
setuserdata(T, FrameTag, UserData);
% Handles of sliders and edit controls are used directly because the table
% object is not available in callback functions.  It's OK to modify the
% Value property of the sliders and the String property of the edit controls, 
% but never change e.g. Parent, Position or Units in this way!
[RowSize, ColSize] = size(UserData.Data);
set(UserData.SliderVHandle, 'Max', RowSize, 'Value', RowSize + 1 - Row);
set(UserData.SliderHHandle, 'Max', ColSize, 'Value', Column);
for m = 1:UserData.RowMax
   DataRow = Row + m - 1;
   for n = 1:UserData.ColMax
      DataCol = Column + n - 1;
      if DataRow < 1 | DataRow > RowSize | DataCol < 1 | DataCol > ColSize
         DataValue = [];
      else
         DataValue = UserData.Data(DataRow, DataCol);
      end
      set(UserData.EditHandles((m-1)*UserData.ColMax + n), 'String', DataValue);
   end
end

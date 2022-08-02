function stepRight(obj)
%STEPRIGHT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/04/04 03:29:18 $

d = get(obj.edit , 'UserData');

%Need to check if we're moving right from the 1st index, which means
%that we have to enable the left button and change it's cdata.
if d.index == 1
   flag = 1;
else
   flag = 0;
end

if d.index == length(d.range)
   %We should never hit this bit of code, as the button should be disabled
   %in the portion of code below from a previous button press.
   return;
end

d.index = d.index + 1;
set(obj.edit , 'string' , num2str(d.range(d.index)));
d.currstr = num2str(d.range(d.index));

%Disable the right button if we've hit it's maximum range.
if d.index == length(d.range)
   set(obj.rightbutton , 'enable' , 'off' , 'cdata' , d.RightDis)
end

if flag
   set(obj.leftbutton , 'enable' , 'on' , 'cdata' , d.LeftEn);
end

set(obj.edit , 'userdata' , d);
xregcallback(d.callback);
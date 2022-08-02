function stepRight(obj)
%STEPLEFT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/04/04 03:29:17 $

d = get(obj.edit , 'UserData');

%Need to check if we're moving let from the max index, which means
%that we have to enable the right button and change it's cdata.
if d.index == length(d.range)
   flag = 1;
else
   flag = 0;
end

if d.index == 1
   %We should never hit this bit of code, as the button should be disabled
   %in the portion of code below from a previous button press.
   return;
end

d.index = d.index - 1;
set(obj.edit , 'string' , num2str(d.range(d.index)));
d.currstr = num2str(d.range(d.index));

%Disable the left button if we've hit it's minimum range.
if d.index == 1
   set(obj.leftbutton , 'enable' , 'off' , 'cdata' , d.LeftDis)
end

if flag
   set(obj.rightbutton , 'enable' , 'on' , 'cdata' , d.RightEn);
end

set(obj.edit , 'userdata' , d);
xregcallback(d.callback);
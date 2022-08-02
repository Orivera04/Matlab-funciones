function typeText(obj)
%TYPETEXT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/04/04 03:29:19 $

str = get(obj.edit , 'string');
d = get(obj.edit , 'UserData');

if isempty(str)
   set(obj.edit , 'string' , d.currstr);
else
   num = str2num(str);
   if isempty(num)
      w = evalin('base' , 'whos');
      names = {w.name};
      ind = strmatch(str , names , 'exact');
      
      if ~isempty(ind)
         name = names{ind};
         num = evalin('base' , name);
         if ~isnumeric(num) | all(size(num) == 1) | num < d.range(1) | num > d.range(end)
            set(obj.edit , 'string' , d.currstr);
         else
            [y,i]=min(abs(d.range-num));
            d.index = i(end);
            if d.index == 1
               set(obj.leftbutton , 'enable' , 'off' , 'cdata' , d.LeftDis);
            else
               set(obj.leftbutton , 'enable' , 'on' , 'cdata' , d.LeftEn);
            end
            if d.index == length(d.range)
               set(obj.rightbutton , 'enable' , 'off' , 'cdata' , d.RightDis);
            else
               set(obj.rightbutton , 'enable' , 'on' , 'cdata' , d.RightEn);
            end
            d.currstr = str;
            set(obj.edit , 'UserData' , d);
            xregcallback(d.callback)
            return;
         end
      else
         set(obj.edit , 'string' , d.currstr);
      end
   elseif all(size(num) == 1) & num >= d.range(1) & num <= d.range(end)
      [y,i]=min(abs(d.range-num));
      d.index = i(end);
      if d.index == 1
         set(obj.leftbutton , 'enable' , 'off' , 'cdata' , d.LeftDis);
      else
         set(obj.leftbutton , 'enable' , 'on' , 'cdata' , d.LeftEn);
      end
      if d.index == length(d.range)
         set(obj.rightbutton , 'enable' , 'off' , 'cdata' , d.RightDis);
      else
         set(obj.rightbutton , 'enable' , 'on' , 'cdata' , d.RightEn);
      end
      d.currstr = str;
      set(obj.edit , 'UserData' , d);
      xregcallback(d.callback)
      return;
   else
      set(obj.edit , 'string' , d.currstr);
   end
end


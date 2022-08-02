function typeText(obj)
%TYPETEXT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/04/04 03:29:21 $

str = get(obj.edit , 'string');
d = get(obj.edit , 'UserData');

if isempty(str)
   set(obj.edit , 'string' , prettify(d.vector));
else
   num = str2num(str);
   if isempty(num)
      w = evalin('base' , 'whos');
      names = {w.name};
      ind = strmatch(str , names , 'exact');
      if ~isempty(ind)
         name = names{ind};
         new_value = evalin('base' , name);
         if ~isnumeric(new_value) | sum(size(new_value) > 1) > 1
            set(obj.edit , 'string' , prettify(d.vector(:)'));
         else
            set(obj.edit , 'string' , prettify(new_value(:)'));
            d.vector = new_value;
            set(obj.edit , 'UserData' , d);
            xregcallback(d.callback)
            return;
         end
      else
         set(obj.edit , 'string' , prettify(d.vector(:)'));
      end
   elseif sum(size(num) > 1) <= 1
      d.vector = num;
      set(obj.edit , 'UserData' , d);
      set(obj.edit , 'String' , prettify(d.vector));
      xregcallback(d.callback)
      return;
   else
      set(obj.edit , 'string' , d.currstr);
   end
end
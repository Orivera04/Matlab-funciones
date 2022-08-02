function out = get(obj , prop)
%GET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:32:46 $

d = get(obj.edit , 'UserData');
switch lower(prop)
case 'userdata'
   out = d.UserData;
case 'callback'
   out = d.callback;
case 'value'
   out = str2num(get(obj.edit , 'string'));
case 'range'
   out = [d.range(1) d.range(end)];
case 'name'
   out = get(obj.text , 'string');
end

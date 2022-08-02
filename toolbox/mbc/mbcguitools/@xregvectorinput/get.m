function out = get(obj , prop)
%GET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:34:04 $

d = get(obj.edit , 'UserData');
switch lower(prop)
case 'userdata'
   out = d.UserData;
case 'callback'
   out = d.callback;
case 'value'
   out = d.vector;
case 'name'
   out = get(obj.text , 'string');
end

function out = get(obj , prop)
%GET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:20:19 $

d = get(obj.popup , 'UserData');
switch lower(prop)
case 'userdata'
   out = d.UserData;
case 'callback'
   out = d.callback;
case 'string'
   out = d.string;
case 'name'
   out = get(obj.text , 'string');
case 'value'
    out = get(obj.popup, 'value');
end

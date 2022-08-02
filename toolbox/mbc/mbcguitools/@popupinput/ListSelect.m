function ListSelect(obj);
%LISTSELECT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:20:16 $

d = get(obj.popup , 'UserData');
if ~isempty(d.callback)
    eval(d.callback)
end
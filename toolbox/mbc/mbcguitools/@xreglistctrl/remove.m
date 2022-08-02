function obj = remove(obj, index)
%% XREGLISTCTRL/REMOVE
%% to remove controls 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:32:10 $

sh = obj.slider;
fr = obj.frame;
ud = get(sh,'userdata');

for i = index
    delete(ud.controls{i});
end
ud.controls(index) = [];

set(sh,'userdata',ud);

obj=redraw(obj,'full');

function obj= append(obj,new)
%APPEND Append new controls to the list
%
%  APPEND(OBJ, NEWCTRL) appends NEWCTRL to those already in place.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/04/04 03:29:12 $

sh = obj.slider;
ud = get(sh,'userdata');
controls = ud.controls;

if iscell(new)
    ud.controls = [controls, new(:)'];
    for i = 1:length(ud.controls)
        try
            set(ud.controls{i},'callback', {@i_cellcb, obj, i});
        end
    end
end

set(sh,'userdata',ud);

obj = redraw(obj,'cell');

function i_cellcb(src, evt, obj, idx)
callback(obj, idx);

function slider(obj)
%% XREGLISTCTRL/SLIDER
%% the callback from the slider

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:32:13 $

ud = get(obj.slider,'userdata');

%% ensure slider hits integer values.
slVal = round(get(obj.slider,'value'));
set(obj.slider,'value',slVal);

%% slider values  are upside down hence
newTop = get(obj.slider,'max')-slVal+1;
ud.top = newTop;
set(obj.slider,'userdata',ud);

obj = redraw(obj,'cell');
return

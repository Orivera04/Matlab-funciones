function [mout,ok] = gui_globalmodsetup(m,action,varargin)
%GUI_GLOBALMODSETUP  GUI for altering unispline settings
%
%  [M,OK]=GUI_GLOBALMODSETUP(M) creates a blocking GUI for choosing the
%  unispline options and altering its settings.  OK indicates whether the
%  user pressed 'OK' or 'CANCEL'

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.4.4 $  $Date: 2004/04/04 03:30:54 $

if nargin<2
    action = 'figure';
end

switch lower(action)
    case 'figure'
        [mout,ok] = i_createfig(m);
    case 'getclasslevel'
        mout = class(m);
    case 'layout'
        mout = gui_globalmodpane(m,'layout',varargin{:});
    case 'finalise'
        mout = m;
end



function [mout,ok] = i_createfig(m) 
scr = get(0,'screensize');
figh = xregdialog('name','Emulator Settings',...
   'position',[scr(3)*.5-125 scr(4)*.5-60 500 370],...
   'resize','off');

p = xregGui.RunTimePointer(m);
p.LinkToObject(figh);
lyt = gui_globalmodpane(m, 'layout', figh, p);

% add ok, cancel
okbtn = uicontrol('style','pushbutton',...
   'parent',figh,...
   'string','OK',...
   'callback','set(gcbf,''visible'', ''off'', ''tag'',''ok'');');
cancbtn = uicontrol('style','pushbutton',...
   'parent',figh,...
   'string','Cancel',...
   'callback','set(gcbf,''visible'', ''off'', ''tag'',''cancel'');');

lyt = xreggridbaglayout(figh, ...
    'packstatus', 'off', ...
    'dimension', [2 3], ...
    'rowsizes', [-1 25], ...
    'colsizes', [-1 65 65], ...
    'gapx', 7, ...
    'gapy', 7, ...
    'border', [7 7 7 10], ...
    'mergeblock', {[1 1], [1 3]}, ...
    'elements', {lyt, [], [], okbtn, [], cancbtn});

figh.LayoutManager = lyt;
set(lyt, 'packstatus', 'on', 'visible', 'on');
figh.showDialog(okbtn);

tg = get(figh,'tag');
if strcmp(tg, 'ok')
    mout = p.info;
    ok = 1;
else
    mout = m;
    ok = 0;
end
delete(figh);

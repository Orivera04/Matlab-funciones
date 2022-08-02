function obj = xreglistctrl(varargin)
%XREGLISTCTRL Constructor for xreglistctrl object
%
%  L=XREGLISTCTRL
%  L=XREGLISTCTRL(FIG)
%  L=XREGLISTCTRL('Property1',Value1,...)
%  L=XREGLISTCTRL(FIG,'Property1',Value1,...)
%
%  Min dimensions for cell is 25 by 15 pixels
%  Min dimensions for xreglistctrl is 40 by 40 pixels
%
%  Callback to be executed when any control object changes
%  use SET(L, 'CALLBACK', 'CALLBACK STRING');
%
%  Controls must allow the operations:
%  GET(CTRL, 'VALUE')
%  SET(CTRL, 'VISIBLE', 'ON/OFF')
%  SET(CTRL, 'POSTITION',[])
%  DELETE(CTRL)
%  SET(CTRL, 'CALLBACK', 'STRING')
%  and this string must be executed as the final step
%  in the callback of the ctrl object

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.2.3 $  $Date: 2004/04/04 03:29:15 $

% Data stored in ud of slider
ud.position = [10 10 300 300];
ud.sliderwidth = 15;
ud.border = 3;
ud.cellBorder = 2;
ud.controls = {};
ud.cellHeight = 30;
ud.top = 1;
ud.callback = '';
% fixnumcells = optional field. If on, redraw numcells held constant
% normally this field empty and redraw keeps cellheight constant
ud.fixnumcells = [];
ud.userdata = [];

% object fields for frame and slider
obj.slider = [];
obj.frame = [];


% ====== contruction ==========
if nargin>0 && ~ischar(varargin{1}) && ishandle(varargin{1})...
        && strcmp(get(varargin{1},'type'),'figure')
    fh = varargin{1};
    varargin(1) = [];
else
    fh = gcf;
end

border = ud.border;
sliderWidth = ud.sliderwidth;
cellHeight = ud.cellHeight;
controls = ud.controls;
pos = ud.position;
wd = pos(3); ht = pos(4);
numCells = floor((pos(4)-2*border)/cellHeight);

% === draw frame, with slider  ===
framePos = pos;
frame = xregframetitlelayout(fh, ...
    'position',framePos,...
    'packgroup','XREGLISTCTRL', ...
    'packstatus','off', ...
    'visible', 'off');

% NOTE: slider val=1 is bottom so all slider vals seem upsidedown
sliderPos = [pos(1)+wd-sliderWidth-1, pos(2)+1, sliderWidth, ht-2];
slLength = max(length(controls)-numCells+1,1+eps);
slider = uicontrol('parent',fh,...
    'visible', 'off', ...
    'style','slider',...
    'enable','off',...
    'position',sliderPos,...
    'sliderstep',[max(1/slLength,1), max(2/slLength,1+eps)],...
    'max',slLength,...
    'min',1,...
    'value',slLength);

obj.slider = slider;
obj.frame = frame;
obj = class(obj,'xreglistctrl');

set(slider, 'callback', {@i_slidercb, obj});

% This is the object to use when dispatching callbacks.  It allows
% subclasses to capture callbacks while still using callback strings
ud.object = obj;
set(slider,'userdata',ud);

DoVis = true;
if length(varargin)
    % Check for a visible call
    DoVis = ~any(strcmpi('visible',lower(varargin(1:2:end))));
    obj = set(obj,varargin{:});
end
if DoVis
    set(frame,'packstatus','on','visible','on');
else
    set(frame,'packstatus','on');
end

function i_slidercb(src, evt, obj)
slider(obj);

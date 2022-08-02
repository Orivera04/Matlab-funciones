function obj = xregpaneltitlelayout(varargin)
%  Synopsis
%     function obj = xregpaneltitlelayout(parameter,value,parameter,....)
%     function obj = xregpaneltitlelayout(fig,parameter,value,parameter,....)
%
%  Description
%     Creates a xregpaneltitlelayout container in the (optional) figure fig.
%
%  See also
%     xregpaneltitlelayout/set

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.2.3 $  $Date: 2004/02/09 07:36:41 $

fig = [];
if nargin
    if ~ischar(varargin{1}) ...
            && ishandle(varargin{1}) ...
            && strcmp(get(varargin{1},'type'),'figure')
        fig = varargin{1};
        varargin(1) = [];
    end
end
if isempty(fig)
    fig=gcf;
end

c = xregcontainer(fig);

ud.selectmode = 0;
ud.selected = 0;
ud.titleheight = 19;
ud.titleborder = [0 0 0 0];
ud.divider = false;
ud.dividerhandle = [];

udptr=xregGui.RunTimePointer(ud);
connectdata(c, udptr);
obj.ptr = udptr;

obj.title = xregGui.truncateduicontrol('parent',fig,...
    'style','text',...
    'visible','off',...
    'hittest','off',...
    'enable','inactive',...
    'horizontalalignment','left',...
    'usetooltip', false);
obj.ttlpanel = xregGui.filledPanel('parent', fig, ...
    'visible','off',...
    'type', 'out');
obj.outerpanel = xregGui.panel('parent', fig, ...
    'visible','off');
connectdata(c, obj.ttlpanel);
connectdata(c, obj.outerpanel);
connectdata(c, obj.title);

obj = class(obj,'xregpaneltitlelayout',c);

if length(varargin)
    if ~any(strcmp('visible',lower(varargin(1:2:end))))
        % set ui objects to visible
        set(obj,varargin{:});
        set([obj.title; obj.ttlpanel; obj.outerpanel],'visible','on');
    else
        set(obj,varargin{:});
    end
else
    set([obj.title; obj.ttlpanel; obj.outerpanel],'visible','on');
end

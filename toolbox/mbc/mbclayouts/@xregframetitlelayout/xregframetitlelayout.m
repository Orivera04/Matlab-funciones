function obj = xregframetitlelayout(varargin)
%  Synopsis
%     function obj = xregframetitlelayout(parameter,value,parameter,....)
%     function obj = xregframetitlelayout(fig,parameter,value,parameter,....)
%
%  Description
%     Creates a xregframetitlelayout container in the (optional) figure fig.
%
%  See also
%     xregframetitleLayout/set

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:36:15 $

fig=[];
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
ud.borders=[10 10 10 10];
ud.title=0;

% grab a set of axes for positioning in figure
ax = getaxes(xregGui.figureaxes,fig);
sc = xregGui.SystemColorsDbl;
obj.whiteline = xregline('parent',ax,...
    'color',sc.CTRL_LT_HILITE,...
    'hittest','off',...
    'visible','off');
obj.grayline = xregline('parent',ax,...
    'color',sc.CTRL_SHADOW,...
    'hittest','off',...
    'visible','off');
obj.title = xreguicontrol('style','text',...
    'parent',fig,...
    'enable','inactive',...
    'backgroundcolor',sc.CTRL_BACK,...
    'handlevisibility','off',...
    'visible','off',...
    'position',[10 92 50 16]);
set(obj.title,'userdata',ud);
connectdata(c, [obj.whiteline, obj.grayline, obj.title]);

obj = class(obj,'xregframetitlelayout',c);
builtin('set',obj.grayline,'userdata',obj);

% look for a visible set in remaining args
if ~any(strcmp('visible',lower(varargin(1:2:end))))
    % set ui objects to visible
    set([obj.grayline;obj.whiteline],'visible','on');
end
if length(varargin)
    obj = set(obj,varargin{:});
end

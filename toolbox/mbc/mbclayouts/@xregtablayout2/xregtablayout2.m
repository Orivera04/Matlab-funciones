function obj = xregtablayout2(varargin)
%XREGTABLAYOUT2 Tabbed layout derived from cardlayout
%
%  T=XREGTABLAYOUT2 creates a true Windows look'n'feel tablayout.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.2.3 $  $Date: 2004/02/09 07:37:20 $

figh=[];
if nargin
    if ~ischar(varargin{1}) ...
            && ishandle(varargin{1}) ...
            && strcmp(get(varargin{1},'type'),'figure')
        figh = varargin{1};
        varargin(1) = [];
    end
end
if isempty(figh)
    figh=gcf;
end

def_pos = [20 20 130 100];

sc=xregGui.SystemColorsDbl;
ud.bgcol = sc.CTRL_BACK;
ud.callback='';
ud.beforecallback='';

crd = xregcardlayout(figh,'position',def_pos+[2 2 -4 -23]);
nc = get(crd,'numcards');

obj.axes=getbgaxes(xregGui.figureaxes,figh);
obj.whiteline = xregline('xdata',[],'ydata',[],'parent',obj.axes,...
    'visible','off','color',sc.CTRL_LT_HILITE,...
    'clipping','off','hittest','off');
obj.lightline = xregline('xdata',[],'ydata',[],'parent',obj.axes,...
    'visible','off','color',sc.CTRL_HILITE,...
    'clipping','off','hittest','off');
obj.darkline = xregline('xdata',[],'ydata',[],'parent',obj.axes,...
    'visible','off','color',sc.CTRL_SHADOW,...
    'clipping','off','hittest','off');
obj.blackline = xregline('xdata',[],'ydata',[],'parent',obj.axes,...
    'color',sc.CTRL_DK_SHADOW,'visible','off',...
    'clipping','off','hittest','off');
obj.bgpatch = xregpatch('parent',obj.axes,'xdata',[],'ydata',[],'zdata',[],'edgecolor','none',...
    'facecolor',sc.CTRL_BACK,'visible','off',...
    'clipping','off','hittest','off','layer',-1);
connectdata(crd, [obj.whiteline, obj.lightline, obj.darkline, ...
    obj.blackline obj.bgpatch]);

obj = class(obj,'xregtablayout2',crd);


% create controls for labels
for n=1:nc
    ud.tablabels(n) = xreguicontrol('parent',figh,'style','text',...
        'position',[0 0 40 15],...
        'horizontalalignment','left',...
        'visible','off',...
        'interruptible','off',...
        'buttondownfcn',{@i_tabsel,obj,n},...
        'string',['Tab' sprintf('%d',n)],...
        'enable','inactive',...
        'backgroundcolor',sc.CTRL_BACK);
end
if nc>0
    connectdata(obj, ud.tablabels);
end

% set extents to default minimum
ud.tabextents = 40*ones(1,nc);
ud.tabsdrawn = 0;
ud.visible = 0;
ud.mintabsize = 40;
ud.innerborder=[0 0 0 0];
ud.enabled=ones(1,nc);
ud.buttonloc = 0;    % top buttons

% look for a visible set in remaining args
if ~any(strcmp('visible',lower(varargin(1:2:end))))
    % set ui objects to visible
    set([obj.whiteline;obj.blackline;obj.lightline;obj.darkline;obj.bgpatch;ud.tablabels(:)],'visible','on');
    ud.visible = 1;
end

% set up data stores
set(obj.whiteline,'userdata',ud);

if length(varargin)
    set(obj,varargin{:});
end

ud=get(obj.whiteline,'userdata');
% if the tabs haven't been updated by a set call, redraw here
if ~ud.tabsdrawn
    % complete the drawing of tab objects in a private function
    pr_draw3D(obj);
    pr_drawlabels(obj);
    ud=get(obj.whiteline,'userdata');
    ud.tabsdrawn=1;
    set(obj.whiteline,'userdata',ud);
end


function i_tabsel(src,evt,obj,n)
cb_tabsel(obj,n);

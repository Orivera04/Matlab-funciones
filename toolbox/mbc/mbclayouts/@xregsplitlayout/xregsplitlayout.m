function obj = xregsplitlayout(varargin)
%  Synopsis
%     function obj = xregsplitlayout(parameter,value,parameter,....)
%     function obj = xregsplitlayout(fig,parameter,value,parameter,....)
%
%  Description
%     Creates a xregsplitlayout container in the (optional) figure fig.
%
%  See also
%     xregsplitlayout/set

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:37:13 $

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
    fig = gcf;
end

c = xregcontainer(fig);

obj.datastore = xregGui.RunTimePointer;
connectdata(c, obj.datastore);
ud.split = [0.5 0.5];
ud.resizable = 1;
ud.orientation = 0;  % left-right orientation by default
obj.rsbutton = uicontrol('parent',fig,...
    'style','pushbutton',...
    'value',1,...
    'visible','off',...
    'enable','off');
connectdata(c, obj.rsbutton);
obj.PointerRegion = xregGui.MotionManager;
obj.PointerRegion.ExternalRef = obj.rsbutton;
obj.PointerRegion.UseExternalRef = 'on';

ud.divstyle = 1;
ud.divwidth = 3;
ud.callbackstr = '';
ud.innerborderl = [0 0 0 0];
ud.innerborderr = [0 0 0 0];
ud.visible = 1;
ud.minwidth = [0 0];
ud.minwidthunits = 'pixels';
ud.MousePtrID = -1;
obj.datastore.info = ud;

obj = class(obj,'xregsplitlayout',c);

% look for a visible set in remaining args
if ~any(strcmp('visible',lower(varargin(1:2:end))) | strcmp('resizable',lower(varargin(1:2:end))))
    % set ui objects to visible and attach MotionManager
    set(obj.rsbutton,'visible','on');
    MM = MotionManager(fig);
    MM.RegisterManager(obj.PointerRegion);
end
if length(varargin)
    obj = set(obj,varargin{:});
end

obj.PointerRegion.MouseInFcn= {@mousetracker, obj, 1};
obj.PointerRegion.MouseOutFcn= {@mousetracker, obj, -1};
set(obj.rsbutton,'buttondownfcn',{@resizebar,obj})

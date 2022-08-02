function obj = xregtoolbarlayout(varargin)
%  Synopsis
%     function obj = xregtoolbarlayout(parameter,value,parameter,....)
%     function obj = xregtoolbarlayout(fig,parameter,value,parameter,....)
%
%  Description
%     Creates a xregtoolbarlayout container in the (optional) figure fig.
%
%  See also
%     xregtoolbarlayout/set

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:37:27 $

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
sc = xregGui.SystemColorsDbl;

obj.tb = xregGui.uitoolbar('parent',fig, 'visible', 'off');
obj.panel = xregGui.panel('parent',fig, 'visible', 'off');
obj.tbListener = [];
obj.spacer = xregGui.oblong(fig,'color',sc.CTRL_BACK, 'visible', 'off');

ud.SpacerW=4;
obj.rtP = xregGui.RunTimePointer(ud);

connectdata(c, obj.rtP);
connectdata(c, obj.tb);
connectdata(c, obj.panel);
connectdata(c, obj.spacer);

obj = class(obj,'xregtoolbarlayout',c);

% look for a visible set in remaining args
if ~any(strcmp('visible',lower(varargin(1:2:end))))
    % set ui objects to visible
    set([obj.tb;obj.panel;obj.spacer],'visible','on');
end
if length(varargin)
    set(obj,varargin{:});
end

obj.tbListener = handle.listener(obj.tb,findprop(obj.tb,'DesiredHeight'),...
    'PropertyPostSet',{@i_setTBHeight,obj});



function i_setTBHeight(srcobj,evt,obj)
% adjust the layout's proportions
repack(obj);

function obj  = xregpanellayout(varargin)
%  Synopsis
%     function obj = xregpanellayout(parameter,value,parameter,....)
%     function obj = xregpanellayout(fig,parameter,value,parameter,....)
%
%  Description
%     Creates a xregpanelLayout container in the (optional) figure fig.
%
%  See also
%     xregpanelLayout/set

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:36:36 $

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

% Default borders give single-line panels an explorer look
ud.borders = [0 1 0 -2];   
ud.userdata = [];
% State is 1=depressed (normal) or 0=outwards (line colours switched)
ud.state = 1;             

obj.panel = xregGui.panel('parent', fig, ...
    'visible','off');
connectdata(c, obj.panel);
obj.rtP = xregGui.RunTimePointer(ud);
connectdata(c, obj.rtP);

obj = class(obj,'xregpanellayout',c);

% look for a visible set in remaining args
if ~any(strcmp('visible',lower(varargin(1:2:end))))
    % set ui objects to visible
    set(obj.panel,'visible','on');
end
if length(varargin)
    obj = set(obj,varargin{:});
end

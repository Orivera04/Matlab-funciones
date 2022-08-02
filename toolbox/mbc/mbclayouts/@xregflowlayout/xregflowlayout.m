function obj = xregflowlayout(varargin)
%  Synopsis
%     function obj = xregflowlayout(parameter, value, parameter, .... )
%     function obj = xregflowlayout(fig,parameter, value, parameter, .... )
%
%  Description
%     Creates a xregflowlayout container in the (optional) figure fig.
%
%  See also
%     xregflowlayout/set

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:36:02 $

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
obj.g = xregGui.RunTimePointer;
connectdata(c, obj.g);

ud.type = 'flowLayout';
ud.orientation = 'LEFT/TOP';
ud.expand = 'OFF';
ud.gap = 0;
obj.g.info=ud;

obj = class(obj,'xregflowlayout',c);

set(obj,varargin{:});
